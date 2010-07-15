$(function() {
  // Ajax history, only works on the product.reviews for now
  

  $(".suppendre_newsletter").live("click", function() {
    url = $(this).attr('href');
    html_item = $(this).parent();
    content = html_item.html();
    loader = 'ajax-loader.gif';
    html_item.html("<img src='/images/"+loader+"'/>");
    $.ajax({
      url: url,
      type: 'POST',
      success: function(data) {
        item = html_item.html(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });

  $(".suppendre_newsletter_parnter").live("click", function() {
    url = $(this).attr('href');
    html_item = $(this).parent();
    content = html_item.html();
    loader = 'ajax-loader.gif';
    html_item.html("<img src='/images/"+loader+"'/>");
    $.ajax({
      url: url,
      type: 'POST',
      success: function(data) {
        item = html_item.html(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });
  
  $(".add_normal").live("click", function() {
    url = $(this).attr('href');
    html_item = $(this).parent().parent().parent().parent();
    content = html_item.html();
    loader = 'ajax-loader.gif';
    html_item.html("<div style='height:42px'><img src='/images/"+loader+"'/></div>");
    $.ajax({
      url: url,
      type: 'POST',
      success: function(data) {
        item = html_item.replaceWith(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });

  $(".add_adult").live("click", function() {
    url = $(this).attr('href');
    html_item = $(this).parent().parent().parent().parent();
    content = html_item.html();
    loader = 'ajax-loader.gif';
    html_item.html("<div style='height:42px'><img src='/images/"+loader+"'/></div>");
    $.ajax({
      url: url,
      type: 'POST',
      success: function(data) {
        item = html_item.replaceWith(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });
  $(".modification_account").live("click", function() {
    url = $(this);
    jQuery.facebox(function() {
      $.getScript(url.attr('href'), function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });
  $(".modification_address").live("click", function() {
    url = $(this);
    jQuery.facebox(function() {
      $.getScript(url.attr('href'), function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });
  var options = {
    	success: showResponse  // post-submit callback
	};
  $('#submit_account').live("click", function(){
    loader = 'ajax-loader.gif';
    $('.bouton_probleme').html("<div style='height:42px'><img src='/images/"+loader+"'/></div>")
    $('.content form').ajaxSubmit(options);
    return false; // prevent default behaviour
  });
  $('#submit_address').live("click", function(){
    loader = 'ajax-loader.gif';
    $('.bouton_probleme').html("<div style='height:42px'><img src='/images/"+loader+"'/></div>")
    $('.content form').ajaxSubmit(options);
    return false; // prevent default behaviour
  });
    	 
  // post-submit callback
  function showResponse(responseText, statusText)  {
  	if(jQuery.trim(responseText) == "Success"){
  	  $.facebox.close;
  	  window.location.href = window.location.pathname;
    } else {
    	$('.content').html(responseText);
    }
  }
  $('#change_password').live("click", function(){
    
    $('#password').html('<input type="password" value="" size="30" name="customer[clear_pwd]" id="customer_clear_pwd">')
    $('#password_confirmation').show();
    $(this).hide();
    return false; // prevent default behaviour
  });
  
  $(".suppendre").live("click", function() {
    url = $(this);
    jQuery.facebox(function() {
      $.getScript(url.attr('href'), function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });
});
