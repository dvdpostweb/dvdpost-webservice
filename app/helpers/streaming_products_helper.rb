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
end
