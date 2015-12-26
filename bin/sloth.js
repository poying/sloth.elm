#!/usr/bin/env node

'use strict';

var co = require('co');
var program = require('commander');
var pkg = require('../package');
var run = require('../lib/run');

program
  .version(pkg.version)
  .usage('[options] <file>')
  .option('--reporter [reporter_name]', 'choose a reporter', /^(ansi|json)$/, 'ansi')
  .option('--root [dirname]', 'change root dir path', process.cwd())
  .parse(process.argv);

const files = program.args;

if (!files.length) {
  program.help();
}

co(function *() {
  let result = yield run(files, program);
  console.log();
  console.log(result.output);
  console.log();
  process.exit(result.success ? 0 : 1);
}).catch(function (err) {
  console.log(err.message);
  process.exit(1);
});
