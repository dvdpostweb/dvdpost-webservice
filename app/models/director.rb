require 'open-uri'
require 'json'
require 'htmlentities'
class Director < ActiveRecord::Base
  set_primary_key :directors_id

  def self.get_all_data(id = nil)
    if id.nil?
      director = Director.all()
    else
      director = Director.all(:conditions => ['directors_id > ?', id])
    end
    director.each do |a|
      a.get_url3
    end
    nil
  end
  def get_url3(url_start = nil)
    if url_start.nil?
      name = directors_name.gsub(' ','%20').gsub("'",'%27')
      name = name.downcase.gsub(/[ÁàáâãäåÅ]/i,'a').gsub(/æ/,'ae').gsub(/ç/, 'c').gsub(/[èéêë]/i,'e').gsub(/[öôøôóÔòÔ]/i,'o').gsub(/[íîïì]/i,'i').gsub(/[üú]/i,'u').gsub(/[ñ]/i,'n').gsub(/[ý]/i,'y')
      #url = "/Users/gs/Documents/rien.html"
      url = "http://www.imdb.com/find?q=#{name}&s=nm"
    else
      url = url_start
    end
    begin
      data = open url
      hp = Hpricot(data)
      error = false
    rescue => e
      puts "error open url #{url} #{e}"
      error = true
    end
    if  error == false
      title = hp.search('#img_primary/a/img')
      birth = hp.search('a[@href*=birth_place]')
      if title.empty? && birth.empty?
        if url_start.nil?
          title = hp.search("p[@style*=0 0 0.5em 0]").search('b')
          eval = title.text.include?('Media')
          if eval
            string= title.search('a').first['onclick'].gsub(/.*link=/,"\1")
            t = string.gsub(/[^0-9]/,'').to_s
            get_url3('http://www.imdb.com/name/nm'+t)
            #get_url3('http://www.imdb.fr/name/nm0000169/')
          else
            puts "error search #{name} #{to_param}"
          end
        else
          puts "error #{url_start}"
        end
      else
        if !title.empty?
          get_image_2(title.first['src'])
        end
        if !birth.empty?
          i=0
          death_at = death_place = birth_at = birth_place = nil
          hp.search('div.txt-block').each do |res|
            i = i + 1
            time = res.search("time")
            if d = res.search('a[@href*=birth_place]').first
              a = d.inner_html
              birth_place = a
              birth_at = time.first['datetime'] if time.first
            elsif dd = res.search('a[@href*=death_place]').first
              a = dd.inner_html
              death_place = a
              death_at = time.first['datetime'] if time.first
            end
          end
          if birth_at
            update_attributes(:directors_dateofbirth => birth_at, :birth_place => birth_place, :death_place => death_place, :death_at => death_at)
          end
        end
      end
    end 
  end

  def get_image_2(src)
    begin
      image_url = "/Users/gs/Documents/directors/jpg/#{to_param}.jpg"
      open(image_url, 'wb') do |file|
        file << open(src).read
      end
      update_attribute(:image_active, 1)
    rescue => e
      puts e
    end
  end

  def get_url
    name = directors_name.gsub(' ','%20').gsub("'",'%27')
    name = name.downcase.gsub(/[ÁàáâãäåÅ]/i,'a').gsub(/æ/,'ae').gsub(/ç/, 'c').gsub(/[èéêë]/i,'e').gsub(/[öôøôóÔòÔ]/i,'o').gsub(/[íîïì]/i,'i').gsub(/[ü]/i,'u').gsub(/[ñ]/i,'n').gsub(/[ý]/i,'y')
    #puts name
    url = "http://www.canalplay.com/library/Pelican/Ajax/Adapter/Jquery/public/?route=Layout_Infinity_Ajax_RechercheRapide/index&values[]=#{name}&callback=jQuery16105098426083602796_1339160543515&_=1339160564920"
    #puts url
    begin
      data = open(url).read
      json = data.gsub(Regexp.new(/jQuery.*\(/),'')
      json=json[0..-2]
      t=JSON.parse(json)
      nb = t['contents'].size
      if nb == 1
        self.get_image(t['contents'][0]['url'].gsub(' ','%20').gsub("'",'%27'))
      elsif nb > 1
        puts "many results #{name}" 
      else
        update_attribute(:image_active, 0)
      end
    rescue => e
      puts "#{url} #{e}"
    end
  end
  def get_image(url)
    data = open("http://www.canalplay.com#{url}")
    node = Hpricot(data).search('div.video/img')
    image_url = "/Users/gs/Documents/directors/#{to_param}.png"
    open(image_url, 'wb') do |file|
      file << open(node.first['src']).read
    end
    if File.size(image_url) > 4000
      update_attribute(:image_active, 1)
    else
      update_attribute(:image_active, 0)
    end
  end
end