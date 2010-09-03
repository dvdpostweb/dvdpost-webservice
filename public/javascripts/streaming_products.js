$(function() {
  $('.play').live("click", function() {
    $.ajax({
      url: $(this).attr('href'),
      type: 'GET',
      data: {},
      success: function(data) {
        $('#player').html(data);
      },
      error: function() {
        //$(this).html(content);
      }
      
    });
    return false;
  });
});