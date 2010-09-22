module StreamingProductsHelper
  def flowplayer(source_file, token_name)
    script = <<-script
    $f("player", "/flowplayer/flowplayer-3.1.5.swf", {
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
            "hideDelay":500,
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
    if validation
      token = validation[:token]
      status = validation[:status]
    end
    if token && status == Token.status["IP_TO_CREATED"]
      "<div class ='attention_vod'>#{t '.ip_to_created'}</div>"
    elsif !token && unavailable_token
      "<div class ='attention_vod'>#{t '.old_token'}</div>"
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
