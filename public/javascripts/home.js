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
  
  $('#home_recommendations #carousel-wrap-hp a.next_page').live('click',function(){
    url = this.href;
    html_item_recommendation = $('#home_recommendations');
    content = html_item_recommendation.html()
    $.ajax({
      url: url,
      type: 'GET',
      success: function(data) {
        html_item_recommendation.replaceWith(data);
      },
      error: function() {
        html_item_recommendation.replaceWith(content);
      }
    });
    return false;
  });
  
  $('#home_recommendations #carousel-wrap-hp a.prev_page').live('click',function(){
    url = this.href;
    html_item_recommendation = $('#home_recommendations');
    content = html_item_recommendation.html()
    $.ajax({
      url: url,
      type: 'GET',
      success: function(data) {
        html_item_recommendation.replaceWith(data);
      },
      error: function() {
        html_item_recommendation.replaceWith(content);
      }
    });
    return false;
  });
  $('#home_popular #carousel-wrap-hp a.next_page').live('click',function(){
    url = this.href;
    html_item = $('#home_popular');
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
  
  $('#home_popular #carousel-wrap-hp a.prev_page').live('click',function(){
    url = this.href;
    html_item = $('#home_popular');
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
  var current;
  setCurrent(5);
  $container = $('.panels').cycle({ 
      fx: 'turnLeft', 
      timeout: 15000,
      before: change_carousel
  });
  
  function getCurrent()
  {
    return current;
  }
  function setCurrent(_current)
  {
    current = _current;
  }
  $('.menu_carousel').click(function() { 
      id = $(this).attr('id');
      id = parseInt(id.replace("carousel_",""),10);
      setCurrent(id-1)
      $container.cycle(id-1); 
      return false; 
  });
  function change_carousel()
  {
    setCurrent(getCurrent() + 1);
    if(getCurrent() == 6) setCurrent( 1);
    $('#tabs-rotator #tabs a.active').removeClass('active');
    $('#carousel_'+getCurrent()).addClass('active');
  }
});
