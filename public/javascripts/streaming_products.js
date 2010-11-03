$(function() {
  
  
  var isIE  = (navigator.appVersion.indexOf("MSIE") != -1) ? true : false;
  var isWin = (navigator.appVersion.toLowerCase().indexOf("win") != -1) ? true : false;
  var isOpera = (navigator.userAgent.indexOf("Opera") != -1) ? true : false;

  // JavaScript helper required to detect Flash Player PlugIn version information
  
  <script language="VBScript"> 
    <!-- // Visual basic helper required to detect Flash Player ActiveX control version information Function VBGetSwfVer(i) on error resume next Dim swControl, swVersion swVersion = 0 set swControl = CreateObject("ShockwaveFlash.ShockwaveFlash." + CStr(i)) if (IsObject(swControl)) then swVersion = swControl.GetVariable("$version") end if VBGetSwfVer = swVersion End Function // --> 
  </script>
  function JSGetSwfVer(i){
        // NS/Opera version >= 3 check for Flash plugin in plugin array
        if (navigator.plugins != null && navigator.plugins.length > 0) {
              if (navigator.plugins["Shockwave Flash 2.0"] || navigator.plugins["Shockwave Flash"]) {
                    var swVer2 = navigator.plugins["Shockwave Flash 2.0"] ? " 2.0" : "";
                          var flashDescription = navigator.plugins["Shockwave Flash" + swVer2].description;
                          descArray = flashDescription.split(" ");
                          tempArrayMajor = descArray[2].split(".");
                          versionMajor = tempArrayMajor[0];
                    if ( descArray[3] != "" ) {
                          tempArrayMinor = descArray[3].split("r");
                    } else {
                          tempArrayMinor = descArray[4].split("r");
                    }
                          versionMinor = tempArrayMinor[1] > 0 ? tempArrayMinor[1] : 0;
                          flashVer = parseFloat(versionMajor + "." + versionMinor);
              } else {
                    flashVer = -1;
              }
        }
        // MSN/WebTV 2.6 supports Flash 4
        else if (navigator.userAgent.toLowerCase().indexOf("webtv/2.6") != -1) flashVer = 4;
        // WebTV 2.5 supports Flash 3
        else if (navigator.userAgent.toLowerCase().indexOf("webtv/2.5") != -1) flashVer = 3;
        // older WebTV supports Flash 2
        else if (navigator.userAgent.toLowerCase().indexOf("webtv") != -1) flashVer = 2;
        // Can't detect in all other cases
        else {

              flashVer = -1;
        }
        return flashVer;
  }

  /*for (i=25;i>0;i--) {      
    if (isIE && isWin && !isOpera) {
          versionStr = VBGetSwfVer(i);
    } else {
          versionStr = JSGetSwfVer(i);
    } 
  }*/
  
  
  $('.qualityvod').live("click", function() {
    content = $('#presentation').html()
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
        $('#presentation').html('')
      },
      error: function() {
        $('#presentation').html(content);
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
  versionStr+='';
  v = versionStr.split('.');
  version = parseInt(v[0]);
  if (versionStr == -1 || version <= 9)
  {
    $('.quality').hide();
    go('<div style="width:500px;" class="attention_vod">'+$('#flash_problem').html()+'</div>')
  }
  if ($('#old_token').html()!= undefined)
  {
    go('<div style="width:500px;" class="attention_vod">'+$('#old_token').html()+'</div>')
  }
  if ($('#ip_to_created').html()!=undefined)
  {
    go('<div style="width:500px;" class="attention_vod">'+$('#ip_to_created').html()+'</div>')
  }
  
});