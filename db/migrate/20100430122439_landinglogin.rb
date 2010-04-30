class Landinglogin < ActiveRecord::Migration
  def self.up
	add_column :landings, :login, :boolean
  end

  def self.down
	remove_column :landings, :login
  end
end
