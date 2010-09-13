class AddNumberIpTokens < ActiveRecord::Migration
  def self.up
    add_column :tokens, :count_ip, :integer, :default => 2
  end

  def self.down
    remove_column :tokens, :count_ip
  end
end
