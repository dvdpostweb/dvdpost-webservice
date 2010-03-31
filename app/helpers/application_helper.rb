# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def product_media_id(media)
    case media
    when 'DVD', 'HDD', 'PS3', 'Wii' then media.downcase
    when 'BlueRay'                  then 'bluray'
    when 'XBOX 360'                 then 'xbox'
    else ''
    end
  end
end
