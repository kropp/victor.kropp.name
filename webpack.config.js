var webpackConfig = {
  entry: {
    index: './assets/index.js'
  },
  output: {
    path: './static/res',
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
