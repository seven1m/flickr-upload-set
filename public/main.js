$(function() {
  $('a[data-path]').each(function() {
    $(this).click(function(e) {
      e.preventDefault();
      var elm = $(this);
      $.post('/select', {path: elm.data('path')}, function() {
        elm.parents('li').addClass('found');
      });
    });
  });
});
