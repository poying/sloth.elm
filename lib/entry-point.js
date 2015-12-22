'use strict';

var os = require('os');
var path = require('path');
var writeFile = require('fs').writeFile;
var randomstring = require('randomstring');

module.exports = function *(root, files) {
  files = absoluteFiles(files);
  let content = generateEntryPoint(root, files);
  let file = path.resolve(os.tmpdir(), randomstring.generate() + '.elm');
  yield function (cb) {
    writeFile(file, content, cb);
  };
  return file;
};

function generateEntryPoint(root, files) {
  let modules = importModules(root, files);
  let tests = createTests(modules);
  let imports = createImports(modules);
  let mod = 'module Main (tests) where';
  return [mod, imports, tests].join('\n\n\n');
}

function createTests(modules) {
  let list = testList(modules);
  return `tests = ${list}`;
}

function createImports(modules) {
  return modules
    .map(function (mod) {
      return mod.import;
    })
    .join('\n');
}

function testList(modules) {
  let items = modules
    .map(testListItem)
    .join(',');
  return `[${items}]`;
}

function testListItem(mod) {
  return `("${mod.file}", ${mod.name}.tests)`;
}

function importModules(root, files) {
  return files
    .map(importModule.bind(null, root));
}

function importModule(root, file) {
  let name = pathToModuleName(root, file);
  return {
    import: `import ${name}`,
    name: name,
    file: file
  };
}

function pathToModuleName(root, file) {
  if (file.startsWith(root)) {
    file = file.substr(root.length);
  }
  file = file
    .replace(/^\//, '')
    .replace(/\.elm$/, '');
  return file
    .split(path.sep)
    .join('.');
}

function absoluteFiles(files) {
  return files.map(function (file) {
    return path.resolve(file);
  });
}
