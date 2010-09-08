class TokensMultiple < ActiveRecord::Migration
  def self.up
    remove_column :tokens, :ip
    create_table :token_ips do |t|
      t.integer :token_id
      t.string :ip
      t.timestamps
    end
  end

  def self.down
    add_column :tokens, :ip, :string
    drop_table :tokens_ips
  end
end
