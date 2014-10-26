$(document).ready(function() {
  $('#notice').click(function() {
    $(this).animate({height: 0, 'padding-top': 0, 'padding-bottom': 0}, {duration: 300, complete: function() {
      $(this).remove();
    }});
  });
});