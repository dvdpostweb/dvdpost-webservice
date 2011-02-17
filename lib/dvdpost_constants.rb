module DVDPost
  class << self
    def dvdpost_ip
      HashWithIndifferentAccess.new.merge({
        :external   => ['217.112.190.73', '217.112.190.101', '217.112.190.177', '217.112.190.178', '217.112.190.179', '217.112.190.180', '217.112.190.181', '217.112.190.182'],
        :internal => '127.0.0.2'
      })
    end
  end
end
