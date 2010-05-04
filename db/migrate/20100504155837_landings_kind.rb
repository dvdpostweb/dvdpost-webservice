class LandingsKind < ActiveRecord::Migration
  def self.up
    rename_column :landings, :type, :kind 
  end

  def self.down
    rename_column :landings, :kind, :type 
  end
end
