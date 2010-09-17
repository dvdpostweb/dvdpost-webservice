$(function() {
  $('#out_hdmi').live('click', function(){
    menu1_selected($(this))
    show(1,1,1,1,0,0,1)
  })
  $('#out_dvi').live('click', function(){
    menu1_selected($(this))
    show(1,1,1,1,0,0,0)
  })
  $('#out_vga').live('click', function(){
    menu1_selected($(this))
    show(0,1,1,1,1,1,1)
  })
  $('#out_svideo').live('click', function(){
    menu1_selected($(this))
    show(0,0,0,0,1,1,1)
  })
  $('#in_hdmi').live('click', function(){
    menu2_selected($(this))
  })

  $('#in_dvi').live('click', function(){
    menu2_selected($(this))
  })
  $('#in_vga').live('click', function(){
    menu2_selected($(this))
  })
  $('#in_component').live('click', function(){
    menu2_selected($(this))
  })
  $('#in_scart').live('click', function(){
    menu2_selected($(this))
  })
  $('#in_scart').live('click', function(){
    menu2_selected($(this))
  })
  $('#in_composite').live('click', function(){
    menu2_selected($(this))
  })
  $('#in_svideo').live('click', function(){
    menu2_selected($(this))
  })

  function menu1_selected(self)
  {
    $('#guide_output li').removeClass('li_chosen');
    $('#guide_output li').children('div').removeClass('guide_chosen');
    $('#guide_output li').children('p').removeClass('p_chosen');
    $(self).addClass('li_chosen');
    $(self).children('div').addClass('guide_chosen');
    $(self).children('p').addClass('p_chosen');
    out_id = $(self).attr('id');
    out_image = out_id.replace('out_', '');
    $('#video_output').children('img').attr('src','/images/res_'+out_image+'.gif')
    
    menu2_selected();
    $('#video_suggestion').hide();
    $('#audio_suggestion').hide();
    
    
    
  }
  function menu2_selected(self)
  {
    $('#guide_input li').removeClass('li_chosen');
    $('#guide_input li').children('div').removeClass('guide_chosen');
    $('#guide_input li').children('p').removeClass('p_chosen');
    if (self != undefined)
    {
      $(self).addClass('li_chosen');
      $(self).children('div').addClass('guide_chosen');
      $(self).children('p').addClass('p_chosen');
      in_id = $(self).attr('id');
      in_image = in_id.replace('in_', '');
      locale = $('#locale_db').html();
      pix_locale=locale
      if (locale =='en')
      {
        pix_locale ='nl'
      }
      switch(out_image)
      {
        case 'hdmi':
          switch(in_image)
          {
            case 'hdmi':
              link = "http://www.pixmania.be/be/"+pix_locale+"/r/cable-hdmi-vers-hdmi"
              break;
            case 'dvi':
              link = "http://www.pixmania.be/be/"+pix_locale+"/76633/art/pixmania/cable-hdmi-male-dvi-d-mal.html"
              break
            case 'vga':
              link = "http://www.amazon.co.uk/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=hdmi+to+vga&x=0&y=0&tag=|076-21"
              break
            case 'component':
              link = "http://www.amazon.co.uk/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=hdmi+to+component&x=0&y=0&tag=|076-21"
              break
            case 'composite':
              link = "http://www.amazon.co.uk/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=hdmi+to+composite&x=0&y=0&tag=|076-21"
              break
          }
        break;
        case 'dvi':
          switch(in_image)
          {
            
            case 'hdmi':
              link = "http://www.pixmania.be/be/"+pix_locale+"/76633/art/pixmania/cable-hdmi-male-dvi-d-mal.html"
              break;
            case 'dvi':
              link = "http://www.pixmania.be/be/"+pix_locale+"/4317170/art/pixmania/cable-dvi-d-male-vers-dvi.html"
              break
            case 'vga':
              link = "http://www.pixmania.be/be/"+pix_locale+"/4317167/art/pixmania/cable-dvi-male-vers-vga-m.html"
              break
            case 'component':
              link = "http://www.pixmania.be/jeux-video-component-cable-ps3-1-7m/befr617438_jvart.html"
              break
          }
        break;
        case 'vga':
          switch(in_image)
          {
            case 'dvi':
              link ="http://www.nierle.com/"+locale+"/article/8537/Cable_VGA_vers_DVI-A_DVI_Analog_-_1,8_m.html"
            break;
            case 'vga':
              link ="http://www.pixmania.be/be/"+pix_locale+"/3991296/art/pixmania/cable-vga-mc340-3m-male-m.html"
            break;
            case 'scart':
              link ="http://www.nierle.com/"+locale+"/article/8542/Peritel_male_vers_VGA_female_-_2,0_m.html"
            break;
            case 'svideo':
              link ="http://www.amazon.co.uk/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=vga+to+svideo&x=0&y=0&tag=|076-21"
            break;
            case 'component':
              link ="http://www.amazon.co.uk/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=vga+to+component&x=0&y=0&tag=|076-21"
            break;
            case 'composite':
              link ="http://www.amazon.co.uk/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=vga+to+composite&x=0&y=0&tag=|076-21"
            break;
          }
        break;
        case 'svideo':
         switch(in_image)
         {
           case 'scart':
             link ="http://www.nierle.com/"+locale+"/article/8053/Cable_de_raccordement_Peritel_a_Video-Audio_3.0_m.html"
           break;
           case 'svideo':
             link ="http://www.pixmania.be/be/"+locale+"/2694761/art/thomson/cable-s-video-male-male-p.html"
           break;
           case 'composite':
             link ="http://www.pixmania.be/"+pix_locale+"/fr/3950599/art/iberia-pc/cable-pc-to-tv-s-video-3.html"
           break;
         } 
      }
      in_name = $(self).children('p').html()
      $('#video_input').children('img').attr('src','/images/res_'+in_image+'.gif')
      out_name = $('#guide_output li.li_chosen').children('p').html()
      $('#video_input').children('p').html(in_name)
      $('#video_output').children('p').html(out_name)
      cable_type = $('#cable').html();
      cable_type = cable_type.replace('[out]',out_name).replace('[in]',in_name)
      $('#video_suggestion .cable_name').html(cable_type)
      $('#video_suggestion .guide_buy').attr('href',link)
      $('#video_suggestion').show();
      if($(self).attr('id')=='in_hdmi' && $('#guide_output li.li_chosen').attr('id') == 'out_hdmi')
      {
        $('#audio_suggestion').hide();
      } 
      else
      {
        $('#audio_suggestion').show();
      }     
    }
    
  }  
  function show(in_hdmi,in_dvi,in_vga,in_component,in_scart,in_svideo,in_composite)
  {
    ((in_hdmi==1) ? $('#in_hdmi').show() : $('#in_hdmi').hide());
    ((in_dvi==1) ? $('#in_dvi').show() : $('#in_dvi').hide());
    ((in_vga==1) ? $('#in_vga').show() : $('#in_vga').hide());
    ((in_component==1) ? $('#in_component').show() : $('#in_component').hide());
    ((in_scart==1) ? $('#in_scart').show() : $('#in_scart').hide());
    ((in_svideo==1) ? $('#in_svideo').show() : $('#in_svideo').hide());
    ((in_composite==1) ? $('#in_composite').show() : $('#in_composite').hide());
  }
  function getUrlVars()
  {
      var vars = [], hash;
      var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
      for(var i = 0; i < hashes.length; i++)
      {
          hash = hashes[i].split('=');
          vars.push(hash[0]);
          vars[hash[0]] = hash[1];
      }
      return vars;
  }
});