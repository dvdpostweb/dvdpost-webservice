$(function() {
  $(".wishlist_item_priority").live("click", function() {
    html_item = $(this).parent().parent()
    content = html_item.html();
    html_item.html("Updating...");
    wishlist_item_id = this.id;
    priority = this.value;
    locale_short = $('#locale').html();
    $.ajax({
      url: '/'+locale_short+'/wishlist_items/' + wishlist_item_id,
      contentType: 'application/json; charset=utf-8',
      type: 'PUT',
      data: JSON.stringify({"wishlist_item": {"priority": priority}}),
      success: function(data) {
        html_item.html(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
  });

  $(".trash a").live("click", function() {
    if (confirm($("#confirm").html())) {
      content = $(this).html();
      parent_div = $(this).parent();
      parent_div.html("<img src='/images/ajax-loader.gif' />");
      $.ajax({
        url: $(this).attr('href'),
        type: 'DELETE',
        data: {},
        success: function() {
          parent_div.parent().remove();
        },
        error: function() {
          $(this).html(content);
        }
      });
    };
    return false;
  });

  $(document).bind("fragmentChange.transit_or_history", function() {
    $.getScript($.queryString(document.location.href, { 'transit_or_history': $.fragment().transit_or_history }));
  });
  if ($.fragment().transit_or_history) {
    $(document).trigger("fragmentChange.transit_or_history");
  }
  $("a.transit_or_history").live("click", function() {
    html_item = $(this);
    content = html_item.html();
    html_item.html("Loading ...");
    $.ajax({
      url: html_item.attr('href'),
      type: 'GET',
      success: function(data) {
        $(".on-way-with-nav").html(data);
        $.setFragment({ transit_or_history: $.queryString(html_item.attr('href')).transit_or_history })
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });

  $('.report_transit_item, .report_history_item').live('click', function(){
    url = $(this).attr('href');
    jQuery.facebox(function() {
      $.getScript(url, function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });
  
  $('.add_problem_space a').live("click", function() {
    $('#add_problem').html("<p align='center'><img src='/images/loading.gif' /></p>");
  });
  $(".products-pagination a").live("click", function() {
    html_item = $(this);
    root_item = $(this).parent().parent().parent();
    content = html_item.parent().html();
    html_item.parent().html("Loading...");
    $.ajax({
      url: html_item.attr('href'),
      type: 'GET',
      success: function(data) {
        root_item.html(data);
      },
      error: function() {
        html_item.parent().html(content);
      }
    });
    return false;
  });
  /*var options = {
    	//success: showResponse  // post-submit callback
	};
	function showResponse(responseText, statusText)  {
    	//$("#wishlist #carousel").html(responseText);
    	
  }
  $('.add_to_wishlist_button').live("click", function(){
    loader = 'ajax-loader.gif';
    $(this).parent('.add_to_wishlist').ajaxSubmit(options);
    $(this).parent().html("<div style='height:20px'><img src='/images/"+loader+"'/></div>")
    return false; // prevent default behaviour
  });
  */
  $("a.add_to_wishlist_button").live("click", function() {
      content = $(this).html();
      $(this).removeClass('btn');
      $(this).html("<div style='height:31px'><img src='/images/ajax-loader.gif' /></div>");
      $.ajax({
        url: $(this).attr('href'),
        type: 'POST',
        data: {},
        success: function() {
        },
        error: function() {
          $(this).html(content)
        }
      });
    return false;
  });
  
  $("a.btn_remove").live("click", function() {
      content = $(this).html();
      $(this).removeClass('btn_remove');
      $(this).html("<div style='height:31px'><img src='/images/ajax-loader.gif' /></div>");
      $.ajax({
        url: $(this).attr('href'),
        type: 'DELETE',
        data: {},
        success: function() {
        },
        error: function() {
          $(this).html(content)
        }
      });
    return false;
  });
  
  $('#carousel a.next_page').live('click',function(){
    url = this.href;
    html_item = $('#popular_tab');
    content = html_item.html()
    $.ajax({
      url: url,
      type: 'GET',
      success: function(data) {
        html_item.replaceWith(data);
      },
      error: function() {
        html_item.replaceWith(content);
      }
    });
    return false;
  });
  
  $('#carousel a.prev_page').live('click',function(){
    url = this.href;
    html_item = $('#popular_tab');
    content = html_item.html()
    $.ajax({
      url: url,
      type: 'GET',
      success: function(data) {
        html_item.replaceWith(data);
      },
      error: function() {
        html_item.replaceWith(content);
      }
    });
    return false;
  });
  
});
