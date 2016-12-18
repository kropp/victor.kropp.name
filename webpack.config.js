var webpackConfig = {
  entry: {
    index: './assets/index.js'
  },
  output: {
    path: './dist',
    filename: '[name].js'
  },
  module: {
    loaders: [
      { test: /\.css$/, loader: "style-loader!css-loader" },
      { test: /\.png$/, loader: "url-loader" }
    ]
  }
};

module.exports = webpackConfig;
