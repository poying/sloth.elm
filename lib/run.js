'use strict';

var os = require('os');
var path = require('path');
var phantom = require('phantom');
var readFile = require('fs').readFile;
var binPath = require('phantomjs').path;
var exec = require('child_process').exec;
var randomstring = require('randomstring');

process.env.PATH += ':' + path.dirname(binPath);

module.exports = function *(inputFile, reporter) {
  let outputFile = path.resolve(os.tmpdir(), randomstring.generate() + '.js');
  yield compile(inputFile, outputFile);
  return yield load(outputFile, reporter);
};

function *compile(inputFile, outputFile) {
  let command = `elm-make --yes --output ${outputFile} ${inputFile}`;
  yield function (cb) {
    let options = {
      cwd: path.resolve(__dirname, '..')
    };
    exec(command, options, cb);
  };
}

function *load(filepath, reporter) {
  let js = yield function (cb) {
    readFile(filepath, 'utf8', cb);
  };

  let ph = yield function (cb) {
    phantom.create(function (ph) {
      cb(null, ph);
    });
  };

  let page = yield function (cb) {
    ph.createPage(function (page) {
      cb(null, page);
    });
  };

  let result = yield function (cb) {
    page.evaluate(function (js, reporter) {
      var script = document.createElement('script');
      script.innerHTML = js;
      document.body.appendChild(script);

      var elm = Elm.worker(Elm.Main, {});
      var main = Elm.Main.make(elm);
      var sloth = Elm.Sloth.make(elm);
      var reporters = Elm.Sloth.Reporters.make(elm);

      return reporters[reporter](main.tests);
    }, function (result) {
      cb(null, result);
    }, js, reporter);
  };

  ph.exit();

  return result;
}
