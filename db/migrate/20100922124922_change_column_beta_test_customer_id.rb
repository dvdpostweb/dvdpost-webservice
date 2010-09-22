class ChangeColumnBetaTestCustomerId < ActiveRecord::Migration
  def self.up
    rename_column :beta_tests, :customers_id, :customer_id
  end

  def self.down
    rename_column :beta_tests, :customer_id, :customers_id
  end
end
