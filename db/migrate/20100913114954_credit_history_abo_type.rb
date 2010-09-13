class CreditHistoryAboType < ActiveRecord::Migration
  def self.up
    add_column :credit_history, :abo_type, :integer
  end

  def self.down
    remove_column :credit_history, :abo_type
  end
end
