'use strict';

var os = require('os');
var path = require('path');
var phantom = require('phantom');
var readFile = require('fs').readFile;
var binPath = require('phantomjs').path;
var exec = require('child_process').exec;
var entryPoint = require('./entry-point');
var randomstring = require('randomstring');

process.env.PATH += ':' + path.dirname(binPath);

module.exports = function *(files, options) {
  let reporter = options.reporter || 'ansi';
  let root = path.resolve(options.root || process.cwd());
  let entry = yield entryPoint(root, files);
  let output = path.resolve(os.tmpdir(), randomstring.generate() + '.js');
  yield compile(root, entry, output);
  return yield run(output, reporter);
};

function *compile(root, inputFile, outputFile) {
  let command = `elm-make --yes --output ${outputFile} ${inputFile}`;
  yield function (cb) {
    let options = {
      cwd: root
    };
    exec(command, options, cb);
  };
}

function *run(filepath, reporter) {
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
      var result = reporters[reporter](main.tests);

      return {
        output: result._0,
        success: result.ctor === 'Ok'
      };
    }, function (result) {
      cb(null, result);
    }, js, reporter);
  };

  ph.exit();

  return result;
}
