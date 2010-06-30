class LandingsType < ActiveRecord::Migration
  def self.up
    change_column :landings, :type, 'enum("MOVIE", "OTHER", "TOP", "THEME")'
  end

  def self.down
    change_column :landings, :type, 'enum("MOVIE", "OTHER", "SELECTION")'
  end
end
