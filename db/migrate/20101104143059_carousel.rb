class Carousel < ActiveRecord::Migration
  def self.up
    change_column :landings, :kind, 'enum("MOVIE", "OTHER", "TOP", "THEME", "CATEGORY", "ACTOR", "DIRECTOR","OLD_SITE", "STREAMING_PRODUCT", "URL")'
    add_column :product_lists, :style, 'enum("NORMAL", "STREAMING")'
  end

  def self.down
    change_column :landings, :kind, 'enum("MOVIE", "OTHER", "TOP", "THEME", "CATEGORY", "ACTOR", "DIRECTOR","OLD_SITE")'
    remvove_column :product_lists, :style
  end
end
