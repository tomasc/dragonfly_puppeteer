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
    pdf: './script/src/pdf.coffee',
    screenshot: './script/src/screenshot.coffee'
  },
  target: 'node',
  externals: [nodeExternals()],
  output: {
    filename: '[name].js',
    library: '@tomasc/dragonfly_puppeteer',
    libraryTarget: 'umd',
    path: path.resolve(__dirname, 'script/dist'),
    umdNamedDefine: true
  }
}
