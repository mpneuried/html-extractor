(function() {
  var HTMLExtractor, getHTML, request, should, testData, _extractor;

  HTMLExtractor = require("../lib/html_extractor");

  testData = require("./test_data");

  request = require("request");

  should = require("should");

  _extractor = new HTMLExtractor(true);

  getHTML = function(link, cb) {
    request.get(link, function(err, data) {
      if (err) {
        throw err;
      }
      cb(data.body);
    });
  };

  describe('HTML-dispatch-TEST', function() {
    before(function(done) {
      done();
    });
    after(function(done) {
      done();
    });
    describe('TEST Parser', function() {
      it("Test tcs.de HTML", function(done) {
        _extractor.extract(testData.html[0], function(err, data) {
          if (err) {
            throw err;
          }
          should.exist(data.meta);
          should.exist(data.meta.title);
          data.meta.title.should.equal("TCS: Team Centric Software GmbH &amp; Co. KG");
          should.exist(data.body);
          data.body.should.not.be.empty;
          data.body.should.not.include("$('#contactform')");
          data.body.should.not.include(".testcssselector");
          done();
        });
      });
      it("Test spiegel.de HTML", function(done) {
        _extractor.extract(testData.html[1], function(err, data) {
          if (err) {
            throw err;
          }
          should.exist(data.meta);
          should.exist(data.meta.title);
          data.meta.title.should.equal("SPIEGEL ONLINE - Nachrichten");
          should.exist(data.body);
          data.body.should.not.be.empty;
          done();
        });
      });
    });
    describe('Test Request', function() {
      return it("test get HTML", function(done) {
        getHTML(testData.links[0], function(html) {
          html.should.be.a("string");
          html.length.should.be.above(0);
          html.should.include("Team Centric Software GmbH");
          done();
        });
      });
    });
    describe('Test Parser with multiple pages', function() {
      var idx, _fn, _i, _len, _link, _ref;
      _ref = testData.links.slice(0, 6);
      _fn = function(_link) {
        return it("" + idx + ": Parse '" + _link + "'", function(done) {
          getHTML(_link, function(html) {
            _extractor.extract(html, function(err, data) {
              if (err) {
                throw err;
              }
              should.exist(data.meta);
              should.exist(data.meta.title);
              should.exist(data.body);
              data.body.should.not.be.empty;
              done();
            });
          });
        });
      };
      for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
        _link = _ref[idx];
        _fn(_link);
      }
    });
    return describe('Test reducing', function() {
      var idx, _i, _len, _reduce, _ref, _results;
      _ref = testData.reduce;
      _results = [];
      for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
        _reduce = _ref[idx];
        _results.push((function(_reduce) {
          return it("" + idx + ": Reduced parse '" + _reduce.url + "'", function(done) {
            getHTML(_reduce.url, function(html) {
              _extractor.extract(html, _reduce.reduced, function(err, data) {
                if (err) {
                  throw err;
                }
                should.exist(data.meta);
                should.exist(data.meta.title);
                should.exist(data.body);
                data.body.should.not.be.empty;
                switch (idx) {
                  case 0:
                    data.body.should.not.include("EDV-Downloadbereich");
                    data.body.should.not.include("Spitalgasse 31");
                    data.body.should.include("Herzlich willkommen im APO-Shop");
                    break;
                  case 1:
                    data.body.should.not.include("steht zum Verkauf");
                    data.body.should.not.include("Preis: Verhandlungsbasis");
                    data.body.should.include("Sichtbarkeit mit e-sparschwein.de");
                }
                done();
              });
            });
          });
        })(_reduce));
      }
      return _results;
    });
  });

}).call(this);
