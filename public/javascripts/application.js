$.ajaxSettings.accepts._default = "text/javascript, text/html, application/xml, text/xml, */*";
$(function() {
  // Enable fragmetChange. This will allow us to put ajax into browser history
  $.fragmentChange(true);

  // hides the slickbox as soon as the DOM is ready
  // (a little sooner than page load)
  $('#lang-box').hide();
  $('body').click(function() {
    $('#indicator-tips').hide();
  });

  // toggles the slickbox on clicking the noted link
  $('a#lang').click(function() {
    $('#lang-box').toggle(50);
    return false;
  });

  $("#indicator #n7").click(function() {
    $("#indicator-tips").toggle(0);
    $.getScript($(this).attr('href'));
    return false;
  });

  $("#close").click(function() {
    $("#indicator-tips").hide();
    $.getScript($("#close a").attr('href'));
    return false;
  });

  $(".datepicker").datepicker({
    disabled: true,
    showButtonPanel: false 
  });

  $(".streaming_action").live("click", function() {
    wishlist_item = $(this);
    jQuery.facebox(function() {
      $.getScript(wishlist_item.attr('href'), function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });

});
