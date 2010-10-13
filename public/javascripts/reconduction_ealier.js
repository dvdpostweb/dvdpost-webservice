$(function() {
  $('#show_all').live('click',function(){
    $('.abo').show();
    $(this).hide();
    return false;
  });
  
  $('#left_content .choice').live('click',function(){
    $('#left_content').addClass('active');
    $('#right_content').removeClass('active');
    $('.abo .check').removeClass('active');
    $('.abo').removeClass('active');
    $('#customer_next_abo_type_id').attr('value','')
    
  });
  
  $('#right_content .choice').live('click',function(){
    $('#left_content').removeClass('active');
    $('#right_content').addClass('active');
  });
  
  $('.abo .check').live('click',function(){
    $('.abo .check').removeClass('active');
    $('.abo').removeClass('active');
    $(this).addClass('active');
    $(this).parent().parent().addClass('active');
    id = $(this).attr('id')
    $('#customer_next_abo_type_id').attr('value',id);
    
    $('#left_content').removeClass('active');
    $('#right_content').addClass('active');
  });
  
});
