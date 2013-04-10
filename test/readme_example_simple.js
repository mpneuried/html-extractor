(function() {
  var Extrator, html, myExtrator;

  Extrator = require("../lib/html_extractor");

  myExtrator = new Extrator();

  html = "<html>\n	<head>\n		<title>Testpage</title>\n	</head>\n	<body>\n		<h1>Header 1</h1>\n		<p>Content</p>\n	</body>\n</html>";

  myExtrator.extract(html, function(err, data) {
    if (err) {
      throw err;
    } else {
      console.log(data);
    }
  });

}).call(this);
