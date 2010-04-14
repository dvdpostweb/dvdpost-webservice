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

  $(".star").mouseover(function(){
    nb_star=$(this).attr('id');
    for(var i=1; i<=5;i++)
    {
      if(i<=nb_star)
      $('#'+i).attr('src','/images/star-voted-on.jpg');
      else
      $('#'+i).attr('src','/images/star-voted-off.jpg');
    }
  });

  $(".star").click(function(){
    rate=$(this).attr('id');
    data="rate="+rate;
    $.post($(this).parents('form').attr('action'), data, null, "script");
    return false;
  });

  $(".star").mouseout(function(){
    for(var i=1; i<=5;i++)
    {
      type=$('#'+i).attr('type');
      switch(type)
      {
        case 'full':
        $('#'+i).attr('src','/images/star-on.jpg');
        break;
        case 'half':
        $('#'+i).attr('src','/images/star-half.jpg');
        break;
        case 'empty':
        $('#'+i).attr('src','/images/star-off.jpg');
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
    $("#oscars-text").css({'height':'inherit'});
    $("#oscars").hide();
    return false;
  });

  $(".yn .yes").click(function(){
    $.ajax({
      url: "/fr/reviews/"+$(this).attr('review_id')+"/review_rating/",
      contentType: 'application/json; charset=utf-8',
      type: 'POST',
      data: JSON.stringify({"review_rating": {"rate": $(this).attr('rate')}})
    });
    return false;
  });
});
