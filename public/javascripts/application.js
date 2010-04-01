// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
  // hides the slickbox as soon as the DOM is ready
  // (a little sooner than page load)
  $('#lang-box').hide();
  $('#indicator-tips').hide();

  // toggles the slickbox on clicking the noted link  
  $('a#lang').click(function() {
    $('#lang-box').toggle(50);
    return false;
  });

  $("#indicator #n6").click(function(event){
    $("#indicator-tips").toggle(0);
    return false;
  });

  $("#close").click(function(event){
    $("#indicator-tips").hide();
    return false;
  });
});
