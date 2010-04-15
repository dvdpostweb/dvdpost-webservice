$(function() {
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

  $(".star").click(function() {
    rate=$(this).attr('nb');
	product_id = $(this).attr('product_id');
    data="rate="+rate;
	$("#rating-stars"+product_id).html("<img src='/images/ajax-loader.gif' />")
    $.post($(this).parents('form').attr('action'), data, null, "script");
    return false;
  });
  $(".star").mouseover(function(){
    nb_star = $(this).attr('nb');
	product_id = $(this).attr('product_id');
    for(var i=1; i<=5;i++)
    {
      if(i<=nb_star)
      $('#'+product_id+"_"+i).attr('src','/images/star-voted-on.jpg');
      else
      $('#'+product_id+"_"+i).attr('src','/images/star-voted-off.jpg');
    }
  });
  $(".star").mouseout(function() {
	product_id = $(this).attr('product_id');
    for(var i=1; i<=5;i++)
    {
      type=$('#'+product_id+"_"+i).attr('type');
      switch(type)
      {
        case 'full':
        $('#'+product_id+"_"+i).attr('src','/images/star-on.jpg');
        break;
        case 'half':
        $('#'+product_id+"_"+i).attr('src','/images/star-half.jpg');
        break;
        case 'off':
        $('#'+product_id+"_"+i).attr('src','/images/star-off.jpg');
        break;
      }
    }
  });

  $("#add_to_wishlist_button").live("click", function() {
    jQuery.facebox(function() {
      $.getScript($("#add_to_wishlist_button").attr('href'), function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });

  $(".action .links a").live("click", function() {
    html_item = $(this).parent();
    content = html_item.html();
    html_item.html("Saving...");
    $.ajax({
      url: this.href,
      type: 'POST',
      success: function(data) {
        html_item.html(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });

  $("#oscars a").click(function() {
    html_item = $('#oscars_text');
    content = html_item.html();
    $.ajax({
      url: this.href,
      dataType: 'script',
      type: 'GET',
      success: function(data) {
        html_item.html(data);
        $("#oscars").hide();
      },
      error: function() {
        html_item.html(content);
        $("#oscars").hide();
      }
    });
    return false;
  });
});
