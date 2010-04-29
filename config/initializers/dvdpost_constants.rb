module DVDPost
  class << self
    def images_path
      'http://www.dvdpost.be/images'
    end

    def news_url
       HashWithIndifferentAccess.new.merge({
          :fr => 'http://syndication.cinenews.be/rss/newsfr.xml',
          :nl => 'http://syndication.cinenews.be/rss/newsnl.xml',
          :en => 'http://syndication.cinenews.be/rss/newsnl.xml'
        })
    end

    def images_language_path
       HashWithIndifferentAccess.new.merge({
          :fr => 'http://www.dvdpost.be/images/www3/languages/french/images',
          :nl => 'http://www.dvdpost.be/images/www3/languages/dutch/images',
          :en => 'http://www.dvdpost.be/images/www3/languages/english/images'
        })
    end

    def images_shop_path
       HashWithIndifferentAccess.new.merge({
          :fr => 'http://www.dvdpost.be/images/www3/languages/french/images/shop',
          :nl => 'http://www.dvdpost.be/images/www3/languages/dutch/images/shop',
          :en => 'http://www.dvdpost.be/images/www3/languages/english/images/shop'
        })
    end
    
    def banner_size
      HashWithIndifferentAccess.new.merge({
        :small => '180x150'
      })
    end

    def product_languages
      HashWithIndifferentAccess.new.merge({
        :fr => 1,
        :nl => 2,
        :en => 3
      })
    end

    def product_publics
      HashWithIndifferentAccess.new.merge({
        'all' => 1,
        '6'   => 5,
        '10'  => 6,
        '12'  => 2,
        '14'  => 7,
        '16'  => 3,
        '18'  => 4
      })
    end

    def local_product_publics
      product_publics.invert
    end

    def product_kinds
      HashWithIndifferentAccess.new.merge({
        :normal       => 'DVD_NORM',
        :adult        => 'DVD_ADULT',
        :subscription => 'ABO'
      })
    end

    def product_types
      HashWithIndifferentAccess.new.merge({
        :dvd    => 'DVD',
        :bluray => 'BlueRay',
        :hdd    => 'HDD',
        :ps3    => 'PS3',
        :wii    => 'Wii',
        :xbox   => 'XBOX 360'
      })
    end

    def trailer_broadcasts_urls
      HashWithIndifferentAccess.new.merge({
        'DAYLYMOTION' => 'http://www.dailymotion.com/video/',
        'YOUTUBE'     => 'http://www.youtube.com/watch?v=',
        'TRUVEO'      => 'http://www.truveo.com/_slug_/id/' # => There is a slug for this url: http://www.truveo.com/backstage-trailer-1/id/1191367212
      })
    end

    def wishlist_priorities
      HashWithIndifferentAccess.new.merge({
        :high   => 1,
        :medium => 2,
        :low    => 3
      })
    end

    def soundtrack_param_names
      HashWithIndifferentAccess.new.merge({
        :mono                     => '1',
        :stereo                   => '2',
        :dolby_surround_pro_logic => '3',
        :dolby_digital            => '4',
        :dts                      => '5',
        :dolby_digital_ex         => '6',
        :dts_hd                   => '7',
        :pcm                      => '8',
        :full_hd                  => '9'
      })
    end

    def home_page_news
      open(news_url[I18n.locale]) do |http|
        RSS::Parser.parse(http.read, false).items
      end
    end

    def cinopsis_critics(imdb_id)
      open("http://www.cinopsis.be/dvdpost_test.cfm?imdb_id=#{imdb_id}") do |data|
        Hpricot(Iconv.conv('UTF-8', data.charset, data.read)).search('//p')
      end
    end

    def home_page_recommendations(customer)
      open("http://partners.thefilter.com/DVDPostService/RecommendationService.ashx?cmd=UserDVDRecommendDVDs&id=#{customer.to_param}&number=100&includeAdult=false&verbose=false") do |data|
        Hpricot(data).search('//dvds').collect{|dvd| dvd.attributes['id']}
      end
    end
  end
end
