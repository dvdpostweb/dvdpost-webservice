$(function() {
  $('.qualityvod').live("click", function() {
    content = $('#player').html()
    loader = 'loading.gif';
    $('.error').html('');
    $('#player').html('')
    $('#presentation').html("<div style='height:389px'><div class='load'><img src='/images/"+loader+"'/></div></div>")
    $.ajax({
      url: $(this).attr('href'),
      type: 'GET',
      data: {},
      success: function(data) {
        
        $('#flow').html(data);
        
        
      },
      error: function() {
        $('#player').html(content);
      }
      
    });
    return false;
  });

  response="#r1"
  $('.q').live('click', function(){
    id = $(this).attr('id');
    try
    {
        $(response).hide();
    }
    catch(e)
    {
    }
    response = "#" + id.replace('q', 'r');
    $(response).show();

    return false;
  })
  function go(text)
  {
    jQuery.facebox(function() {
        jQuery.facebox(text);
    })
    
    
  }
  $.facebox.settings.opacity = 0.4; 
  $.facebox.settings.modal = true; 

  if ($('#old_token').html()!= undefined)
  {
    go('<div style="width:500px;" class="attention_vod">'+$('#old_token').html()+'</div>')
  }
  if ($('#ip_to_created').html()!=undefined)
  {
    go('<div style="width:500px;" class="attention_vod">'+$('#ip_to_created').html()+'</div>')
  }
  
});