class Landings < ActiveRecord::Migration
  def self.up
    change_column :landings, :kind, 'enum("MOVIE", "OTHER", "TOP", "THEME", "CATEGORY", "ACTOR", "DIRECTOR")'
    remove_column :landings, :title
  end

  def self.down
    change_column :landings, :kind, 'enum("MOVIE", "OTHER", "TOP", "THEME")'
    add_column :landings, :title, :string
  end
end
