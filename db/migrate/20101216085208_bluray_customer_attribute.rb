class BlurayCustomerAttribute < ActiveRecord::Migration
  def self.up
    add_column :customer_attributes, :bluray_owner, :boolean, :default => 0
  end

  def self.down
    remove_column :customer_attributes, :bluray_owner
  end
end
