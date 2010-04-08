// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  // hides the slickbox as soon as the DOM is ready
  // (a little sooner than page load)
  $('#lang-box').hide();
  $('#indicator-tips').hide();

  // toggles the slickbox on clicking the noted link  
  $('a#lang').click(function() {
    $('#lang-box').toggle(50);
    return false;
  });

  $("#indicator #n6").click(function() {
    $("#indicator-tips").toggle(0);
    return false;
  });

  $("#close").click(function() {
    $("#indicator-tips").hide();
    return false;
  });

  // Ajax history, only works on the product.reviews for now
  $("#tab1 #pagination a").live("click", function() {
    $.setFragment({ reviews_page: $.queryString(this.href).reviews_page })
  });
  $.fragmentChange(true);
  $(document).bind("fragmentChange.reviews_page", function() {
    $.getScript($.queryString(document.location.href, { 'reviews_page': $.fragment().reviews_page }));
  });
  if ($.fragment().reviews_page) {
    $(document).trigger("fragmentChange.reviews_page");
  }

  $("#pagination a").live("click", function() {
    $("#pagination").html("Loading...");
    $.getScript(this.href);
    return false;
  });
});