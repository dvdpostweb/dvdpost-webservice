$(function() {
  $('#news a.next_page').live('click',function(){
    url = this.href;
    html_item = $('#news');
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
  $('#carousel-wrap-hp a.next_page').live('click',function(){
    url = this.href;
    html_item = $('#home_recommendations');
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
  $('#carousel-wrap-hp a.prev_page').live('click',function(){
    url = this.href;
    html_item = $('#home_recommendations');
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
  
  //carousel
  
  $('.panels').cycle({ 
      fx: 'scrollLeft',
      timeout: 15000,
      before: change_carousel
  });

  function change_carousel()
  {
    id = $('#tabs-rotator #tabs a.active').attr('id')
    next_id = parseInt( id ) + 1
    if( next_id == 6) next_id = 1;
    $('#tabs-rotator #tabs a.active').removeClass('active')
    $('#'+next_id).addClass('active')
  }
});
