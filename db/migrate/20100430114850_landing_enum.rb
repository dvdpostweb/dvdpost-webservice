class LandingEnum < ActiveRecord::Migration
  def self.up
    change_column :landings, :type, 'enum("MOVIE", "OTHER", "SELECTION")'
    rename_column :landings, :product_id, reference_id
  end

  def self.down
    change_column :landings, :type, 'enum("MOVIE", "OTHER")'
    rename_column :landings, :reference_id, product_id
  end
end
