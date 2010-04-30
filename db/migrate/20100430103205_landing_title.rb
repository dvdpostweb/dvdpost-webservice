class LandingTitle < ActiveRecord::Migration
  def self.up
	add_column :landings, :title, :string
  end

  def self.down
	remove_column :landings, :title
  end
end
