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

});
