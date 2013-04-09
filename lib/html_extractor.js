(function() {
  var HTMLExtractor, htmlparser, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = [].slice;

  htmlparser = require("htmlparser2");

  _ = require('lodash');

  module.exports = HTMLExtractor = (function() {

    function HTMLExtractor(debug) {
      this.debug = debug != null ? debug : false;
      this._extract = __bind(this._extract, this);
      this.extract = __bind(this.extract, this);
      this._indexOf = __bind(this._indexOf, this);
      this._trim = __bind(this._trim, this);
      return;
    }

    HTMLExtractor.prototype._trimRegex = /^\s+/;

    HTMLExtractor.prototype._trim = function(str) {
      var i;
      if (str == null) {
        str = "";
      }
      str = str.replace(this._trimRegex, "");
      i = str.length - 1;
      while (i >= 0) {
        if (/\S/.test(str.charAt(i))) {
          str = str.substring(0, i + 1);
          break;
        }
        i--;
      }
      return str;
    };

    HTMLExtractor.prototype._indexOf = function(inp, test, offset) {
      return inp.toLowerCase().indexOf(test.toLowerCase(), offset);
    };

    HTMLExtractor.prototype.extract = function() {
      var args, cb, html, reduce, _i, _ret,
        _this = this;
      args = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), cb = arguments[_i++];
      html = args[0], reduce = args[1];
      _ret = {
        meta: {
          title: "",
          description: "",
          keywords: ""
        },
        body: null,
        h1: []
      };
      if (this.debug) {
        console.time("parse Time");
      }
      this._extract(html, _ret, reduce, function(err, data) {
        if (err) {
          cb(err);
          return;
        }
        if (_this.debug) {
          console.timeEnd("parse Time");
        }
        cb(null, data);
      });
    };

    HTMLExtractor.prototype._extract = function(html, _ret, reduce, cb) {
      var parser, _body, _bodyMode, _currTag, _h1LastOpen, _h1Open, _reduce_stack, _scriptMode, _startBody,
        _this = this;
      if (((reduce != null ? reduce.tag : void 0) == null) || (reduce.attr == null) || (reduce.val == null)) {
        reduce = null;
      }
      _bodyMode = false;
      _scriptMode = false;
      _reduce_stack = null;
      _body = [];
      _currTag = null;
      _startBody = null;
      _h1Open = false;
      _h1LastOpen = false;
      parser = new htmlparser.Parser({
        onclosetag: function(name) {
          _currTag = null;
          if ((_reduce_stack != null) && _reduce_stack === parser._stack.join("§§")) {
            _reduce_stack = null;
          }
          switch (name) {
            case "body":
              if (_startBody < parser._tokenizer._index) {
                _bodyMode = false;
              }
              break;
            case "h1":
              _h1Open = false;
              _h1LastOpen = false;
              break;
            case "script":
              _scriptMode = false;
          }
        },
        onopentag: function(name, attr) {
          _currTag = name;
          if ((reduce != null) && reduce.tag === name && attr[reduce.attr] === reduce.val) {
            _reduce_stack = parser._stack.slice(0, -1).join("§§");
          }
          switch (name) {
            case "meta":
              if ((attr != null) && (attr.name != null) && (attr.content != null)) {
                _ret.meta[attr.name] = attr.content;
              } else if ((attr != null) && (attr.charset != null)) {
                _ret.meta.charset = attr.charset;
              }
              break;
            case "body":
              _bodyMode = true;
              _startBody = parser._tokenizer._index;
              break;
            case "script":
              _scriptMode = true;
              break;
            case "h1":
              _h1Open = true;
          }
        },
        ontext: function(text) {
          if (_bodyMode && !_scriptMode) {
            if ((reduce != null) && (_reduce_stack != null)) {
              _body.push(text);
            } else if (reduce == null) {
              _body.push(text);
            }
          }
          if (_h1Open) {
            if (_h1LastOpen) {
              _ret.h1[_ret.h1.length - 1] += _this._trim(text);
            } else {
              _ret.h1.push(_this._trim(text));
            }
            _h1LastOpen = true;
          } else {
            _h1LastOpen = false;
          }
          switch (_currTag) {
            case "title":
              _ret.meta.title += text;
          }
        },
        onend: function() {
          var _word;
          if (_ret.meta.keywords != null) {
            _ret.meta.keywords = (function() {
              var _i, _len, _ref, _results;
              _ref = _ret.meta.keywords.split(",");
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                _word = _ref[_i];
                if (!_.isEmpty(_word)) {
                  _results.push(this._trim(_word));
                }
              }
              return _results;
            }).call(_this);
          }
          _ret.body = _body.join(" ").replace(/\s\s+/g, " ");
          cb(null, _ret);
        }
      }, {
        lowerCaseTags: true
      });
      parser.write(html);
      parser.end();
    };

    return HTMLExtractor;

  })();

}).call(this);
