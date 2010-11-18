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
    title = $(this).parent().parent().children('.title').children().html();
    question = $("#confirm").html();
    
    confirm_sentence =  question.replace('[title]',title);
    if (confirm(confirm_sentence)) {
      parent_div = $(this).parent();
      content = parent_div.html();
      parent_div.html("<img src='/images/ajax-loader.gif' />");
      $.ajax({
        url: $(this).attr('href'),
        type: 'DELETE',
        data: {},
        success: function() {
          parent_div.parent().remove();
        },
        error: function(data) {
          error = $("#error_delete").html();
          error_sentence =  error.replace('[title]',title);
          
          if ($('.flash_error').length == 0){
            $(".container").prepend("<p class='flash_error'>"+error_sentence+"</p>")
            $(".flash_error").css('height','1px')
            $(".flash_error").css('padding','0')
            $(".flash_error").animate({height:16, padding: 10}, 300, "linear", function(){} );
          }else{
            $(".container .flash_error").html(error_sentence)
          }
          
          parent_div.html(content);
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
      html_item=$(this)
      $(this).removeClass('btn_remove');
      $(this).html("<div style='height:31px'><img src='/images/ajax-loader.gif' /></div>");
      $.ajax({
        url: $(this).attr('href'),
        type: 'DELETE',
        data: {},
        success: function() {
        },
        error: function() {
          html_item.html(content)
          html_item.addClass('btn_remove');
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
  
  $(".stars .star, #cotez .star").live("click", function() {
    url = $(this).parent().attr('href');
    html_item = $(this).parent().parent();
    content = html_item.html();
    loader = 'ajax-loader.gif';
    if ($(this).attr('src').match(/black-star-/i)){
      loader = 'black-'+loader;
    }
    html_item.html("<img src='/images/"+loader+"'/>");
    $.ajax({
      url: url,
      type: 'POST',
      data: {},
      success: function(data) {
        $('#popular_tab').replaceWith(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });

  $(".stars .star, #cotez .star").live("mouseover", function(){
    data = $(this).attr('id').replace('star_','').split('_');
    product_id = data[0];
    rating_value = data[1];

    image = 'star-voted-';
    if ($(this).attr('src').match(/black-star-(on|half|off)/i)){
      image = 'black-'+image;
    }
    if ($(this).attr('src').match(/small-star-(on|half|off)/i)){
      image = 'small-'+image;
      ext = 'png'
    }
    else
    {
      ext = 'jpg'
    }
    
    for(var i=1; i<=5; i++)
    {
      if(i <= rating_value){
        full_image = image+'on';
      }else{
        full_image = image+'off';
      }
      $('#star_'+product_id+"_"+i).attr('src', '/images/'+full_image+'.'+ext);
    }
  });

  $(".stars .star, #cotez .star").live("mouseout", function() {
    product_id = $(this).attr('id').replace('star_','').split('_')[0];
    for(var i=1; i<=5; i++)
    {
      image = $('#star_'+product_id+'_'+i);
      image.attr('src','/images/'+image.attr('name'));
    }
  });
  
});
