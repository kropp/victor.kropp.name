require("./site.css");

window.jQuery = require("jquery");

require("fotorama/fotorama.js");
require("fotorama/fotorama.css");

var likely = require("ilyabirman-likely");
window.onload = function() { likely.initiate(); }
require("ilyabirman-likely/release/likely.css");

require("highlightjs").initHighlightingOnLoad();
require("highlightjs/styles/default.css");
