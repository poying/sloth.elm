#!/usr/bin/env node

'use strict';

var co = require('co');
var program = require('commander');
var pkg = require('../package');
var run = require('../lib/run');

program
  .version(pkg.version)
  .usage('[options] <file>')
  .option('-r, --reporter [reporter_name]', 'choose a reporter', /^(ansi|json)$/, 'ansi')
  .parse(process.argv);

const file = program.args[0];

if (!file) {
  program.help();
}

co(function *() {
  let result = yield run(file, program.reporter);
  console.log();
  console.log(result);
  console.log();
}).catch(function (err) {
  console.log(err.message);
});
