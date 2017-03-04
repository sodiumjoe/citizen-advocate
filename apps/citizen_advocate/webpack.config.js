const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: [
    './web/static/js/app.js',
    './web/static/css/app.css',
  ],
  output: {
    path: path.resolve(__dirname, 'priv', 'static'),
    filename: 'js/app.js',
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract({ fallback: 'style-loader', use: 'css-loader' }),
      },
    ],
  },
  plugins: [
    new ExtractTextPlugin('css/app.css'),
    new CopyWebpackPlugin([{ from: './web/static/assets' }]), // doesn't copy new files that are created :(
  ],
};
