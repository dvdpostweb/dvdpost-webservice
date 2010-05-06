class Landinglogin < ActiveRecord::Migration
  def self.up
	add_column :landings, :login, :boolean, :default => 0
  end

  def self.down
	remove_column :landings, :login
  end
end
