# # HTMLExtractor
# 
# Extract meta-data from a html string.
# It extracts the body, title, meta-tags and first headlines to a object to push them to a search indexer like elastic-search

# import external modules
htmlparser = require("htmlparser2")
_ = require('lodash')

# export extractor class
module.exports = class HTMLExtractor

	###
	## constructor
	
	`new HTMLExtractor( debug )`
	
	initializes a extractor instance
	
	@param { Boolean } [debug=false] Output the parsing time
	
	###
	constructor: ( @debug = false )->
		return

	# **_trimRegex** *RegEx* Regular expression for trimming.
	_trimRegex: /^\s+/

	###
	## _trim
	
	`html_extractor._trim( str )`
	
	Trim method to remove whitespace
	
	@param { String } [str=""] String to trim 
	
	@return { String } Trimmed string 
	
	@api private
	###
	_trim: ( str = "")=>
		str = str.replace( @_trimRegex, "")
		i = str.length - 1

		while i >= 0
			if /\S/.test(str.charAt(i))
				str = str.substring(0, i + 1)
				break
			i--
		str

	###
	## extract
	
	`html_extractor.extract( html[, reduce], cb )`
	
	Main method to extract the contens out of a html string
	
	@param { String } html Raw html string to extract the meta, title and body 
	@param { Object } [reduce] Reduce config object to reduce the body results to a specific element. Example: `{ tag: "div", attr: "id", val: "myContent" }`
	@param { Function } reduce Callback function 
	
	@api public
	###
	extract: =>
		# dispatch the arguments
		[ args..., cb ] = arguments
		[ html, reduce ] = args

		# default return Object
		_ret =
			meta: 
				title: ""
				description: ""
				keywords: ""
			body: null
			h1: []
		
		# init benchmarking on `debug = true`
		console.time( "parse Time" ) if @debug

		# run extractor
		@_extract html, _ret, reduce,( err, data )=>
			if err
				cb( err )
				return
			# return time on `debug = true`
			console.timeEnd( "parse Time" ) if @debug

			cb( null, data )
			return
		return

	_extract: ( html, _ret, reduce, cb )=>

		# check the reduce config and disable it if one key is missing
		if not reduce?.tag? or not reduce.attr?  or not reduce.val?
			reduce = null

		# set some flags
		_bodyMode = false
		_scriptMode = false
		_reduce_stack = null
		_body = []
		_currTag = null
		_startBody = null
		_h1Open = false
		_h1LastOpen = false

		# allwasy create a instance of htmlparser2 to prevent race conditions through a possible instance parser value
		parser = new htmlparser.Parser(

			# event on tag open
			onopentag: ( name, attr )=>
				_currTag = name

				# check and start the reduced section by saving the current start stack. The collectin will be done within the `ontext` event.
				if reduce? and reduce.tag is name and attr[ reduce.attr ] is reduce.val
					_reduce_stack = parser._stack.slice( 0,-1 ).join( "§§" )

				switch name
					
					# get the meta tag attributes and set the meta return object
					when "meta"
						if attr? and attr.name? and attr.content?
							_ret.meta[ attr.name ] = attr.content
						#else if attr? and attr.property? and attr.content?
						#	_ret.meta[ attr.property ] = attr.content
						#else if attr? and attr[ 'http-equiv' ]? and attr.content?
						#	_ret.meta[ attr[ 'http-equiv' ] ] = attr.content
						else if attr? and attr.charset?
							_ret.meta.charset = attr.charset

					# start the body section to activate the text body collector 
					when "body"
						_bodyMode = true
						_startBody = parser._tokenizer._index

					# start a script section to prevent text get within scripts
					when "script", "style"
						_scriptMode = true

					# start a h1 section to pull the text in h1 tags out of the html
					when "h1"
						_h1Open = true
				return

			# event on a text fragment
			ontext: ( text )=>

				# check if the parser is in body and not in a script tag
				if _bodyMode and not _scriptMode

					# if reduce is active only push to the body if a stack is defined
					if reduce? and _reduce_stack?
						_body.push( text )
					else if not reduce?
						_body.push( text )

				# if the h1 state is active push the text to the h1 array
				if _h1Open
					# on subtag in the h1 tag the `_h1LastOpen` will be true so the sub tag content will be added to the latest h1 element
					if _h1LastOpen
						_ret.h1[ _ret.h1.length - 1 ] += @_trim( text )
					else
						_ret.h1.push @_trim( text )
					_h1LastOpen = true
				else
					_h1LastOpen = false


				switch _currTag
					# save the content of the title tag to the meta object
					when "title"
						_ret.meta.title += text 

				return
				
			# event on tag close
			onclosetag: ( name )=>
				_currTag = null

				# check if the stack matches the stack on reduce start and stop an active reduce section
				if _reduce_stack? and _reduce_stack is parser._stack.join( "§§" )
					_reduce_stack = null

				switch name
					# stop the body section
					when "body"
						if _startBody < parser._tokenizer._index
							_bodyMode = false
					# stop a h1 section
					when "h1"
						_h1Open = false
						_h1LastOpen = false
					# stop a script section
					when "script", "style"
						_scriptMode = false
				return

				return
			onend: =>
				# if keywords are defined convert it to an array
				if _ret.meta.keywords?
					_ret.meta.keywords = for _word in _ret.meta.keywords.split( "," ) when not _.isEmpty( _word )
						@_trim( _word )

				_ret.body = _body.join( " " ).replace( /\s\s+/g, " " )
				
				cb( null, _ret )
				return

		# allways us lowertags because tags could be written upper or lowercase
		, lowerCaseTags: true )
		
		# push the html to the parser
		parser.write( html )

		# finish the parsing and let the parser call end
		parser.end()

		return