module DVDPost
  class << self
    def images_path
      'http://www.dvdpost.be/images'
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
  end
end
