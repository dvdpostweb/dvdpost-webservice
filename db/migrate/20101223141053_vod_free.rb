class VodFree < ActiveRecord::Migration
  def self.up
    create_table :streaming_products_free do |t|
      t.integer :imdb_id
      t.date :available_from
      t.date :expire_at
      t.boolean :available
      t.timestamps
    end

    add_index :streaming_products_free, :imdb_id
  end

  def self.down
    remove_index :streaming_products_free, :imdb_id

    drop_table :imdb_id
  end
end
