class LangingType < ActiveRecord::Migration
  def self.up
    change_column :landings, :kind, 'enum("MOVIE", "OTHER", "TOP", "THEME", "CATEGORY", "ACTOR", "DIRECTOR","OLD_SITE")'
  end

  def self.down
    change_column :landings, :kind, 'enum("MOVIE", "OTHER", "TOP", "THEME", "CATEGORY", "ACTOR", "DIRECTOR")'
  end
end
