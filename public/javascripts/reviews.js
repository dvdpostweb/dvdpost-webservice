$(function() {
  $("a#add_new_review").live("click", function() {
    review = $(this);
    jQuery.facebox(function() {
      $.getScript(review.attr('href'), function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });

  $(".yn .yes, .yn .no").live("click",function(){
    $(this).parent("p.yn").html('<img src="/images/ajax-loader.gif" />');
    review_id = $(this).attr('review_id');
    html_item = $('#critique'+review_id);
    content = html_item.html();
    $.ajax({
      url: this.href,
      contentType: 'application/json; charset=utf-8',
      type: 'POST',
      data: JSON.stringify({"review_rating": {"rate": $(this).attr('rate')}}),
      success: function(data) {
        html_item.replaceWith(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });
});
