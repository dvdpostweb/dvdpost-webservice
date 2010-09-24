module StreamingProductsHelper
  def flowplayer(source_file, token_name)
    script = <<-script
    $f("player", "/flowplayer/flowplayer.commercial-3.2.4.swf",
    {
      key: '\#$dcba96641dab5d22c24', 
      clip: {
        url: '#{source_file}',
        provider: 'softlayer'
      },

      plugins: {
        softlayer: {
          url: '/flowplayer/flowplayer.rtmp-3.1.3.swf',
          netConnectionUrl: '#{CDN.connect_url(token_name)}'
        },
        controls: {
          autoHide:
          {
            "enabled":true,
            "mouseOutDelay":500,
            "hideDelay":2000,
            "hideDuration":400,
            "hideStyle":"fade",
            "fullscreenOnly":true
          }
        }
      }
    });
    script
    javascript_tag script
  end

  def message_streaming(validation, unavailable_token)
    if !current_customer.payment_suspended?
      if current_customer.credits > 0 || (@token && @status != "IP_TO_CREATED")
        if validation
          token = validation[:token]
          status = validation[:status]
        end
        if token && status == Token.status["IP_TO_CREATED"]
          "<div class ='attention_vod' id ='ip_to_created'>#{t '.ip_to_created'}</div>"
        elsif !token && unavailable_token
          "<div class ='attention_vod' id ='old_token'>#{t '.old_token'}</div>"
        end
      else
        "<div class='attention_vod' id ='credit_empty'>#{t '.credit_empty', :url => reconduction_path}</div>"
      end
    else
      "<div class='attention_vod' id='suspended'>#{t '.customer_suspended'}</div>"
    end
  end
      

      

  def message_error(error)
    case error
      when Token.error["ROLLBACK"] then
        t('.rollback')
      when Token.error["ABO_PROCESS"] then
        t('.abo_process')
      when Token.error["CREDIT"] then
        t('.credit_empty', :url => reconduction_path)
      when Token.error["SUSPENSION"] then
        t('.customer_suspended')
    end
  end
end
