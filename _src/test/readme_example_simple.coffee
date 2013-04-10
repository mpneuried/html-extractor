Extrator = require("../lib/html_extractor")
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
