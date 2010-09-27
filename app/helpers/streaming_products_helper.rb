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

  def message_streaming(token)
    
    token_status = token.nil? ? Token.status[:invalid] : token.current_status(request.remote_ip)

    if !current_customer.payment_suspended?
      if (current_customer.credits <= 0) && !token.valid?(request.remote_ip)
        "<div class='attention_vod' id ='credit_empty'>#{t '.credit_empty', :url => reconduction_path}</div>"
      elsif token_status == Token.status[:ip_invalid]
        "<div class ='attention_vod' id ='ip_to_created'>#{t '.ip_to_created'}</div>"
      elsif token_status == Token.status[:expired]
        "<div class ='attention_vod' id ='old_token'>#{t '.old_token'}</div>"
      end
    else
      "<div class='attention_vod' id='suspended'>#{t '.customer_suspended'}</div>"
    end
  end
      

  def validation(imdb_id, remote_ip, vlavla)
    {:token => nil, :status => Token.status[:FAILED]} 
  end
      

  def message_error(error)
    case error
      when Token.error[:query_rollback] then
        t('.rollback')
      when Token.error[:abo_process_error] then
        t('.abo_process')
      when Token.error[:not_enough_credit] then
        t('.credit_empty', :url => reconduction_path)
      when Token.error[:user_suspended] then
        t('.customer_suspended')
    end
  end
end
