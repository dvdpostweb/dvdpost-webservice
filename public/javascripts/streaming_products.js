$(function() {
  $('.qualityvod').live("click", function() {
    content = $('#player').html()
    loader = 'loading.gif';
    $('#player').html("<div style='height:389px'><div class='load'><img src='/images/"+loader+"'/></div></div>")
    $.ajax({
      url: $(this).attr('href'),
      type: 'GET',
      data: {},
      success: function(data) {
        $('#player').html(data);
      },
      error: function() {
        $(this).html(content);
      }
      
    });
    return false;
  });
});