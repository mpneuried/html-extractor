htmlparser = require("htmlparser2")
_ = require('lodash')

module.exports = class HTMLExtractor

	constructor: ( @debug = false )->

		return

	_trimRegex: /^\s+/
	_trim: ( str = "")=>
		str = str.replace( @_trimRegex, "")
		i = str.length - 1

		while i >= 0
			if /\S/.test(str.charAt(i))
				str = str.substring(0, i + 1)
				break
			i--
		str

	_indexOf: ( inp, test, offset )=>
		return inp.toLowerCase().indexOf( test.toLowerCase(), offset )


	extract: =>

		[ args..., cb ] = arguments
		[ html, reduce ] = args

		_ret =
			meta: 
				title: ""
				description: ""
				keywords: ""
			body: null
			h1: []
		
		console.time( "parse Time" ) if @debug

		@_extract html, _ret, reduce,( err, data )=>
			if err
				cb( err )
				return

			console.timeEnd( "parse Time" ) if @debug

			cb( null, data )
			return
		return

	_extract: ( html, _ret, reduce, cb )=>

		if not reduce?.tag? or not reduce.attr?  or not reduce.val?
			reduce = null

		_bodyMode = false
		_scriptMode = false
		_reduce_stack = null
		_body = []
		_currTag = null
		_startBody = null
		_h1Open = false
		_h1LastOpen = false
		parser = new htmlparser.Parser(
			onclosetag: ( name )=>
				_currTag = null

				if _reduce_stack? and _reduce_stack is parser._stack.join( "§§" )
					_reduce_stack = null

				switch name
					when "body"
						if _startBody < parser._tokenizer._index
							_bodyMode = false
					when "h1"
						_h1Open = false
						_h1LastOpen = false
					when "script"
						_scriptMode = false
				return
			onopentag: ( name, attr )=>
				_currTag = name

				if reduce? and reduce.tag is name and attr[ reduce.attr ] is reduce.val
					_reduce_stack = parser._stack.slice( 0,-1 ).join( "§§" )

				switch name
					when "meta"
						if attr? and attr.name? and attr.content?
							_ret.meta[ attr.name ] = attr.content
						#else if attr? and attr.property? and attr.content?
						#	_ret.meta[ attr.property ] = attr.content
						#else if attr? and attr[ 'http-equiv' ]? and attr.content?
						#	_ret.meta[ attr[ 'http-equiv' ] ] = attr.content
						else if attr? and attr.charset?
							_ret.meta.charset = attr.charset
					when "body"
						_bodyMode = true
						_startBody = parser._tokenizer._index
					when "script"
						_scriptMode = true

					when "h1"
						_h1Open = true
				return
			ontext: ( text )=>
				if _bodyMode and not _scriptMode

					if reduce? and _reduce_stack?
						_body.push( text )
					else if not reduce?
						_body.push( text )

				if _h1Open
					if _h1LastOpen
						_ret.h1[ _ret.h1.length - 1 ] += @_trim( text )
					else
						_ret.h1.push @_trim( text )
					_h1LastOpen = true
				else
					_h1LastOpen = false

				switch _currTag
					when "title"
						_ret.meta.title += text 
				

				return
			onend: =>
				# if keywords are defined convert it to an array
				if _ret.meta.keywords?
					_ret.meta.keywords = for _word in _ret.meta.keywords.split( "," ) when not _.isEmpty( _word )
						@_trim( _word )

				_ret.body = _body.join( " " ).replace( /\s\s+/g, " " )
				
				cb( null, _ret )
				return
		, lowerCaseTags: true )

		parser.write( html )
		parser.end()

		return