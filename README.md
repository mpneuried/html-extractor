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
```

### `new Extrator( debug )`

**arguments**
- **debug** : *( `Boolean` optional: default = `false` )*  
Output the parsing time

## Methods

### Extrator.extract( html[, reduced], cb )

Call `.extract()` to get the data of an html string

**arguments:**

- **html** : *( `String` required )*  
The html string to process
- **reduced** : *( `Object` optional )*  
A object to reduce the content of body to a specific site content. It is not possible to reduce to a tag without a attribute filter.
	- **reduced.tag** : *( `String` required if `reduced` is set )*  
	The tag name of the html element to reduce to
	- **reduced.attr** : *( `String` required if `reduced` is set )*  
	The attribute of the html element to reduce to
	- **reduced.val** : *( `String` required if `reduced` is set )*  
	The attribute value of the html element to reduce to
- **cb** : *( `Function` required )*  
The callback function

**callback arguments:**

- **error** : *( `Error` )*  
Error information. If no error occoured this will be `null`
- **data** : *( `Object` )*  
The extraction result
	- **data.body** : *( `String` )*  
	The whole body content or the content within the configured reduced element. There will be just the text content without html tags/attributes and without the content in script tags.
	- **data.h1** : *( `Array` )*  
	An array containing all `h1` text contents. Including the `h1`elements outside the configured reduced element 
	- **data.meta** : *( `Object` )*  
	A Object of all found meta tags with the syntax `<meta content="" name="">`. Other meta tags will be ignored.
		- **data.meta.charset** : *( `String` optional )*  
		If a metatag with the charset setting like `<meta charset="utf-8" >` is defined it will be returned under `data.meta.charset`
		- **data.meta.title** : *( `String` default = `""` )*  
		If tilte tag is defined it will be returned under `data.meta.title`. Otherwise the key will contain an empty string
		- **data.meta.description** : *( `String` default = `""` )*  
		If a metatag with the name `description` is defined it will be returned under `data.meta.description`. Otherwise the key will contain an empty string
		- **data.meta.keywords** : *( `Array` default = `[]` )*  
		If a metatag with the name `keywords` is defined it will be returned as trimmed array of strings under `data.meta.keywords`. Otherwise the key will contain an empty string

## Examples

### simple

This is a simple example to extarct the content of a html document

```coffee
Extrator = require("html-extractor")
myExtrator = new Extrator()

html = """
<html>
	<head>
		<title>Testpage</title>
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
		console.log data
		# {
		# 	meta: {
		# 		title: 'Testpage',
		#		description: '',
		#		keywords: []
		#	},
		#	body: ' Header 1 Content ',
		#	h1: [ 'Header 1' ]
		# }
	return


```

*see `test/readme_example_simple`*

### advanced

This is a advanced example to show the usage of the reducing.
With the reduce feature it is possible to reduce the body content to the content of a specific html element.

```coffee
Extrator = require("html-extractor")
myExtrator = new Extrator()

html = """
<html>
	<head>
		<title>Super page</title>
		<meta content="X, Y, Z" name="keywords">
		<meta content="Look at this super page" name="description">
		<meta content="Super pageCMS" name="generator">
	</head>
	<body>
		<div id="head">
			<h1>My super page<sup>2</sup></h1>
		</div> 
		<ul id="menu">
			<li>Home</li>
			<li>First</li>
			<li>Second</li>
		</ul>
		<div id="content">
			<h1>First article</h1>
			<p>Lorem ipsum dolor sit amet ... </p>
			<h1>Second article</h1>
			<p>Aenean commodo ligula eget dolor.</p>
			<script>
				var superVar = [ 3,2,1 ]
			</script>
		</div>
		<div id="footer">
			Copyright 2013
		</div>
	</body>
</html>
"""

reduceTo = 
	tag: "div"
	attr: "id"
	val: "content"

myExtrator.extract html, reduceTo, ( err, data )->
	if err
		throw err
	else
		console.log data
		# {
		# 	meta: {
		# 		title: 'Super page',
		# 		description: 'Look at this super page',
		# 		keywords: ['X', 'Y', 'Z'],
		# 		generator: 'Super pageCMS'
		# 	},
		# 	body: ' First article Lorem ipsum dolor sit amet ... Second article Aenean commodo ligula eget dolor. ',
		# 	h1: ['My super page2', 'First article', 'Second article']
		# }
	return

```

*see `test/readme_example_advanced`*

## Work in progress

`html-extractor` is work in progress. Your ideas, suggestions etc. are very welcome.

## Changelog

#### `0.1.3`

* Fixed extraction to remove style-tag content

#### `0.1.2`

* Updated documentation

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