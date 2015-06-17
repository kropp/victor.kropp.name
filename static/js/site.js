$(document).ready(function() { 
  $(document).scroll(function() {
    var opacity = 0.6 + 0.4 * Math.min($(this).scrollTop() / 200, 1);
    $('.navbar-fixed-top').css('background-color', 'rgba(248,248,248,'+opacity+')');
  });
});
