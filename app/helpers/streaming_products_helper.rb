module StreamingProductsHelper
  def flowplayer(source_file, token)
    script = <<-script
    $f("player", "/flowplayer/flowplayer-3.1.5.swf", {
      clip: {
        url: '#{source_file}',
        provider: 'softlayer'
      },

      plugins: {
        softlayer: {
          url: '/flowplayer/flowplayer.rtmp-3.1.3.swf',
          netConnectionUrl: '#{CDN.connect_url(token.token)}'
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
    if token && status == :IP_TO_CREATED
      t '.ip_to_created'
    elsif !token && unavailable_token
      t '.old_token'
    end
  end
end
