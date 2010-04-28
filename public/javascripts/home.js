$(function() {
  $('#news_next').live('click',function(){
    url = this.href;
    max_page = parseInt($(this).attr('max_page'));
    page = parseInt($(this).attr('page'))
    if(page < max_page)
    {
     data = "page=" + parseInt(page + 1);
     html_item = $('#news');
     content = html_item.html()
     $.ajax({
        url: url+'?'+data,
        type: 'GET',
        success: function(data) {
          html_item.replaceWith(data);
        },
        error: function() {
          html_item.replaceWith(content);
        }
      });
    }
    return false;
  });
});
