class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :filters do |t|
      t.references :customer
      t.integer :country_id
      t.integer :audience_min
      t.integer :audience_max
      t.integer :rating_min
      t.integer :rating_max
      t.integer :year_min
      t.integer :year_max
      t.text :audio
      t.text :subtitles
      t.text :media
      t.text :recommended_ids
      t.boolean :dvdpost_choice
      t.timestamps
    end
  end

  def self.down
    drop_table :filters
  end
end
