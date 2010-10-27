$.ajaxSettings.accepts._default = "text/javascript, text/html, application/xml, text/xml, */*";
$(function() {
  // Enable fragmetChange. This will allow us to put ajax into browser history
  $.fragmentChange(true);

  // hides the slickbox as soon as the DOM is ready
  // (a little sooner than page load)
  $('#lang-box').hide();

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

  $("#indicator-tips").click(function() {
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

  $("#tops, #categories").live("click", function() {
    
    id = $(this).attr('id')
    list = "#"+id+"_list"
    $(list).toggle();
    $.getScript($(this).attr('href'));
    if($(list).is(':hidden') == true)
    {
      $(this).removeClass('active')
      url = $(this).attr('href').replace('close', 'open')
      $(this).attr('href',url)
    }
    else
    {
      $(this).addClass('active')
      url = $(this).attr('href').replace('open', 'close')
      $(this).attr('href',url)
      menus = ["tops","categories"]
      for(var i=0; i < menus.length;i++)
      {
        if(menus[i] != id)
        {
          list = "#"+menus[i]+"_list"
          $("#"+menus[i]).removeClass('active')
          $(list).hide()
        }
      }
    }
    return false;
  });

});
