class TokensChange < ActiveRecord::Migration
  def self.up
    add_column :tokens, :customer_id, :integer
    add_column :tokens, :imdb_id, :integer
    remove_column :tokens, :expires_at
    remove_column :tokens, :filename
    
  end

  def self.down
    remove_column :tokens, :customer_id
    remove_column :tokens, :imdb_id
    add_column :tokens, :expires_at, :date
    add_column :tokens, :filename, :string
  end
end
