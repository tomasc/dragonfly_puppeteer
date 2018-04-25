const path = require('path');
const webpack = require('webpack')

module.exports = {
  entry: './script/src/index.js',
  output: {
    library: '@tomasc/dragonfly_puppeteer',
    libraryTarget: 'umd',
    umdNamedDefine: true,
    filename: 'index.js',
    path: path.resolve(__dirname, 'script/dist')
  }
};
