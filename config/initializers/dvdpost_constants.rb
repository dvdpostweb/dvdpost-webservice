module DVDPost
  class << self
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
        '12'  => 2,
        '16'  => 3,
        '18'  => 4,
        '6'   => 5,
        '10'  => 6,
        '14'  => 7
      })
    end

    def product_publics_images
      HashWithIndifferentAccess.new.merge({
        'all' => 'al.gif',
        '12'  => '',
        '16'  => '16.png',
        '18'  => '',
        '6'   => '',
        '10'  => '',
        '14'  => ''
      })
    end

    def product_kinds
      HashWithIndifferentAccess.new.merge({
        :dvd          => 'DVD_NORM',
        :adult        => 'DVD_ADULT',
        :subscription => 'ABO'
      })
    end

    def trailer_broadcasts_urls
      HashWithIndifferentAccess.new.merge({
        'DAILYMOTION' => 'http://www.dailymotion.com/video/',
        'YOUTUBE'     => 'http://www.youtube.com/watch?v=',
        'TRUVEO'      => 'http://www.truveo.com/_slug_/id/' # => There is a slug for this url: http://www.truveo.com/backstage-trailer-1/id/1191367212
      })
    end
  end
end
