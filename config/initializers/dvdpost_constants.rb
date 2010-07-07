module DVDPost
  class << self
    def images_path
      'http://www.dvdpost.be/images'
    end

    def images_carousel_path
      'landings'
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

    def payment_methods
      HashWithIndifferentAccess.new.merge({
        :credit_card  => 1,
        :domicilation => 2
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

    def product_linked_recommendations(product)
      url = "http://partners.thefilter.com/DVDPostService/RecommendationService.ashx?cmd=DVDRecommendDVDs&id=#{product.id}&number=30"
      open url do |data|
        Hpricot(data).search('//dvds').collect{|dvd| dvd.attributes['id']}
      end
    end

    def home_page_recommendations(customer)
      url = "http://partners.thefilter.com/DVDPostService/RecommendationService.ashx?cmd=UserDVDRecommendDVDs&id=#{customer.to_param}&number=100&includeAdult=false&verbose=false"
      open url do |data|
        Hpricot(data).search('//dvds').collect{|dvd| dvd.attributes['id']}
      end
    end

    def send_evidence_recommendations(type, product_id, customer, ip, args=nil)
      url = "http://partners.thefilter.com/DVDPostService/CaptureService.ashx?cmd=AddEvidence&eventType=#{type}&userLanguage=#{I18n.locale.to_s.upcase}&clientIp=#{ip}&userId=#{customer.to_param}&catalogId=#{product_id}"
      url = "#{url}&#{args.collect{|key,value| "#{key}=#{value}"}.join('&')}" if args
      Rails.env == "production" ? open(url) : url
    end

    def product_dvd_statuses
      statuses = OrderedHash.new
      statuses.push(:unreadable,     {:message => 3,  :message_category => 1,  :product_status => 2, :compensation => true})
      statuses.push(:broken,         {:message => 22, :message_category => 2,  :product_status => 4, :compensation => true})
      statuses.push(:damaged,        {:message => 11, :message_category => 11, :product_status => 2, :compensation => false})
      statuses.push(:lost,           {:message => 12, :message_category => 14, :product_status => 5, :compensation => false})
      statuses.push(:delayed,        {:message => 5,  :message_category => 3,  :product_status => 5, :compensation => false, :order_status => 17, :at_home => false})
      statuses.push(:delayed_return, {:message => 7,  :message_category => 5,  :product_status => 5, :compensation => false, :order_status => 18, :at_home => false})
      statuses.push(:envelope,       {})
      statuses.push(:arrived,        {:message => 20, :message_category => 19, :product_status => 1, :compensation => false, :order_status => 2,  :at_home => true})
      statuses
    end
  end
end
