$(function() {
  $('#question_link, #messages_link, #contact_link, #faq_link').live('click',function(){
    old_id = $('#tabs .active').attr('id')
    $('#'+old_id).removeClass('active');
    $(this).addClass('active');
    id = $(this).attr('id');
    old_content = '#'+old_id.replace('_link','');
    new_content = '#'+id.replace('_link','');
    $(old_content).hide();
    $(new_content).show();
    return false;
  });
  $('.menu_faq').live('click',function(){
    $('#faq-nav .active').parent().find("ul").first().hide();
    $('#faq-nav .active').removeClass('active');
    $(this).addClass('active');
    $(this).parent().find("ul").first().show();
  });
  $('.q').live('click',function(){
    id = $(this).attr('id');
    try
    {
      $(response).hide();
    }
    catch(e)
    {}
    response = "#"+id.replace('q','r');
    $(response).show();
    return false;
  });
  $('.categorie').live('click',function(){
    $('label.active').removeClass('active');
    $(this).parent('label').addClass('active');
  });
  
  $('.show').live('click',function(){
    messages_item = $(this);
    jQuery.facebox(function() {
      $.getScript(messages_item.attr('href'), function(data) {
        $(messages_item).parent().parent().removeClass('new');
        jQuery.facebox(data);
      });
    });
    return false;
  });

  $(".trash").live("click", function() {
    if (confirm('Are you sure?')) {
      content = $(this).html();
      parent = $(this).parent()
      parent.html("<img src='/images/ajax-loader.gif' />");
      $.ajax({
        url: $(this).attr('value'),
        type: 'DELETE',
        success: function() {
          parent.parent().parent().remove();
        },
        error: function() {
          $(this).html(content);
        }
      });
    };
    return false;
  });
  
  
});
