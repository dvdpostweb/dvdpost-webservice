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
  $(".content #summer .btn").live("click", function() {
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
  var options = {
    	success: showResponse  // post-submit callback
	};
	function showResponse(responseText, statusText)  {
    	$('#additional_div').html(responseText);
  }
  $('#submit_additional').live("click", function(){
    loader = 'loading.gif';
    $('.content form.new_additional_card').ajaxSubmit(options);
    $(this).parent().html("<div style='height:42px'><img src='/images/"+loader+"'/></div>")
    return false; // prevent default behaviour
  });
  var options_email = {
    	success: showResponseEmail  // post-submit callback
	};
	function showResponseEmail(responseText, statusText)  {
    	$('#emailer').html(responseText);
  }
  $('#mail_send').live("click", function(){
    loader = 'loading.gif';
    $('#tool-wrap #tab1 #inv-form').ajaxSubmit(options_email);
    $(this).parent().html("<p class='loader'><img src='/images/"+loader+"'/></p>")
    return false; // prevent default behaviour
  });


});
