$(function() {
  $("a#new_review").live("click", function() {
    jQuery.facebox(function() {
      $.getScript($("#new_review").attr('href'), function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });
});
