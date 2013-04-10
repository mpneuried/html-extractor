(function() {
  var Extrator, html, myExtrator, reduceTo;

  Extrator = require("../lib/html_extractor");

  myExtrator = new Extrator();

  html = "<html>\n	<head>\n		<title>Super page</title>\n		<meta content=\"X, Y, Z\" name=\"keywords\">\n		<meta content=\"Look at this super page\" name=\"description\">\n		<meta content=\"Super pageCMS\" name=\"generator\">\n	</head>\n	<body>\n		<div id=\"head\">\n			<h1>My super page<sup>2</sup></h1>\n		</div> \n		<ul id=\"menu\">\n			<li>Home</li>\n			<li>First</li>\n			<li>Second</li>\n		</ul>\n		<div id=\"content\">\n			<h1>First article</h1>\n			<p>Lorem ipsum dolor sit amet ... </p>\n			<h1>Second article</h1>\n			<p>Aenean commodo ligula eget dolor.</p>\n			<script>\n				var superVar = [ 3,2,1 ]\n			</script>\n		</div>\n		<div id=\"footer\">\n			Copyright 2013\n		</div>\n	</body>\n</html>";

  reduceTo = {
    tag: "div",
    attr: "id",
    val: "content"
  };

  myExtrator.extract(html, reduceTo, function(err, data) {
    if (err) {
      throw err;
    } else {
      console.log(data);
    }
  });

}).call(this);
