$(function() {
  $("#reconduction").live("click", function() {
    url = $(this).attr('href');
    html_item = $(this);
    content = html_item.html();
    loader = 'ajax-loader.gif';
    html_item.html("<div style='height:42px'><img src='/images/"+loader+"'/></div>");
    $.ajax({
      url: url,
      type: 'PUT',
      data: {},
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
