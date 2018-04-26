const path = require('path');
const webpack = require('webpack')
const fs = require('fs')
const nodeExternals = require('webpack-node-externals')

module.exports = {
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: ['babel-loader', 'coffee-loader'],
        exclude: /node_modules/
      }
    ],
  },
  entry: {
    screenshot: './script/src/screenshot.coffee'
  },
  target: 'node',
  externals: [nodeExternals()],
  output: {
    library: '@tomasc/dragonfly_puppeteer',
    libraryTarget: 'umd',
    umdNamedDefine: true,
    filename: '[name].js',
    path: path.resolve(__dirname, 'script/dist')
  }
}
