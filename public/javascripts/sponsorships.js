$(function() {
  // Ajax history, only works on the product.reviews for now
  name_value=$('#name').attr('value');
  surname_value=$('#surname').attr('value');
  email_value=$('#email').attr('value');
  response="#r1"
  $('#name').live('focus',function(){
    if($(this).attr('value')==name_value)
    {
      $(this).attr('value','')
    }    
  })
  $('#name').live('blur',function(){
    if($(this).attr('value')=='')
    {
      $(this).attr('value',name_value)
    }    
  })
  
  $('#surname').live('focus',function(){
    if($(this).attr('value')==surname_value)
    {
      $(this).attr('value','')
    }    
  })
  $('#surname').live('blur',function(){
    if($(this).attr('value')=='')
    {
      $(this).attr('value',surname_value)
    }    
  })
  
  $('#email').live('focus',function(){
    if($(this).attr('value')==email_value)
    {
      $(this).attr('value','')
    }    
  })
  $('#email').live('blur',function(){
    if($(this).attr('value')=='')
    {
      $(this).attr('value',email_value)
    }    
  })

  $("#modal_invatation, #modal_invatation2").live("click", function() {
    wishlist_item = $(this);
    jQuery.facebox(function() {
      $.getScript(wishlist_item.attr('href'), function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });
  $("#special-offer .btn").live("click", function() {
    wishlist_item = $(this);
    jQuery.facebox(function() {
      $.getScript(wishlist_item.attr('href'), function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });
  
  

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
  i=1
  $('a.add_email, .add_email img').live('click', function(){
    i+=1
    content = $('#inv-form').html() + '<a href="#" class="add_email" class="toggle"><img src="images/toggle+btn.gif" alt=""></a> <input name="name'+i+'" type="text" value="'+name_value+'" id ="name" /> <input name="surname'+i+'" type="text" value="'+surname_value+'" id ="surname" /> <input name="email'+i+'" type="text" value="'+email_value+'" id ="email" /><br /> ';
    
    $('#inv-form').html(content)
    return false;
  })
  

});
