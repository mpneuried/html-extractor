Extrator = require("../lib/html_extractor")
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