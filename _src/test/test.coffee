HTMLExtractor = require( "../lib/html_extractor" )
testData = require( "./test_data" )

request = require( "request" )

should = require( "should" )

_extractor = new HTMLExtractor( true )

getHTML = ( link, cb )->
	request.get link, ( err, data )->
		if err
			throw err
		cb( data.body )
		return
	return

describe 'HTML-dispatch-TEST', ->

	before ( done )->
		done()
		return

	after ( done )->
		done()
		return



	describe 'TEST Parser', ->
		it "Test tcs.de HTML", ( done )->

			_extractor.extract testData.html[ 0 ], ( err, data )->
				if err
					throw err

				should.exist( data.meta )
				should.exist( data.meta.title )
				data.meta.title.should.equal("TCS: Team Centric Software GmbH &amp; Co. KG")
				should.exist( data.body )
				data.body.should.not.be.empty

				data.body.should.not.include( "$('#contactform')" )
				data.body.should.not.include( ".testcssselector" )
				
				#console.log data.meta, data.body.length, data.h1
				done()
				return
			return
		
		it "Test spiegel.de HTML", ( done )->

			_extractor.extract testData.html[ 1 ], ( err, data )->
				if err
					throw err

				should.exist( data.meta )
				should.exist( data.meta.title )
				data.meta.title.should.equal("SPIEGEL ONLINE - Nachrichten")
				should.exist( data.body )
				data.body.should.not.be.empty
				
				#console.log data.meta, data.body.length, data.h1
				done()
				return
			return
		return
	
	describe 'Test Request', ->
		
		it "test get HTML", ( done )->

			getHTML testData.links[ 0 ], ( html )->
				html.should.be.a( "string" )
				html.length.should.be.above( 0 )
				html.should.include( "Team Centric Software GmbH" )
				done()
				return
			return

	describe 'Test Parser with multiple pages', ->
		for _link, idx in testData.links[ 0..5 ]
			do( _link )->
				it "#{ idx }: Parse '#{ _link }'", ( done )->

					getHTML _link, ( html )->

						_extractor.extract html, ( err, data )->
							if err
								throw err
							should.exist( data.meta )
							should.exist( data.meta.title )
							should.exist( data.body )
							data.body.should.not.be.empty
							
							#console.log "\nHEADER of #{ _link }\n", data.meta.title, "\n", JSON.stringify( data.meta, true, 2 ), "\n", JSON.stringify( data.h1, true, 2 )

							done()
							return
						return
					return

		return

	describe 'Test reducing', ->
		for _reduce, idx in testData.reduce
			do( _reduce )->
				it "#{ idx }: Reduced parse '#{ _reduce.url }'", ( done )->
					getHTML _reduce.url, ( html )->

						_extractor.extract html, _reduce.reduced, ( err, data )->
							if err
								throw err
							should.exist( data.meta )
							should.exist( data.meta.title )
							should.exist( data.body )
							data.body.should.not.be.empty

							switch idx
								when 0
									data.body.should.not.include "EDV-Downloadbereich"
									data.body.should.not.include "Spitalgasse 31"

									data.body.should.include "Herzlich willkommen im APO-Shop"
								when 1
									data.body.should.not.include "steht zum Verkauf"
									data.body.should.not.include "Preis: Verhandlungsbasis"

									data.body.should.include "Sichtbarkeit mit e-sparschwein.de"
							
							#console.log "\nBody of #{  _reduce.url }\n", data.body

							done()
							return
						return
					return

	


