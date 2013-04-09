html-extractor
==============

[![Build Status](https://secure.travis-ci.org/mpneuried/html-extractor.png?branch=master)](http://travis-ci.org/mpneuried/html-extractor)

Extract meta-data from a html string. It extracts the body, title, meta-tags and first headlines to a object to push them to a search indexer like elastic-search

## Documentation in progress

*Written in coffee-script*

**INFO: all examples are written in coffee-script**


## Install

```
  npm install html-extractor
```

## Initialize


```coffee
Extrator = require("html-extractor")
myExtrator = new Extrator()

html = """
<html>
	<head>
		<title>Testpage</title>
		<meta content="A, B, C" name="keywords">
	</head>
	<body>
		<h1>Header 1</h1>
		<p>Content</p>
	</body>
</html>
"""

myExtrator.extract html, ( err, data )->
	if err
		throw err
	else
		data // { body: "Header 1 Content", h1: [ "Header 1" ], meta: { keywords: [ "A", "B", "C" ] } }
	return

```

### `new Extrator( debug )`

**arguments**
- **debug** : *( `Boolean` optional: default = `false` )*  
Output the parsing time

### Methods

#### Extrator.extract( html[, reduce], cb )

Call `.extract()` to get the data of an html string

**arguments:**

* `html` ( String - required ): The html string to process
* `reduce` ( Object - optional ): A object to reduce the content of body to a specific site content
* `cb` ( Function - required ): The callback function

## Work in progress

`html-extractor` is work in progress. Your ideas, suggestions etc. are very welcome.

## Changelog

#### `0.1.1`

* Added raw documentation
* Fixed `travis.yml`

#### `0.1.0`

* Initial version

## License 

(The MIT License)

Copyright (c) 2010 TCS &lt;dev (at) tcs.de&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.