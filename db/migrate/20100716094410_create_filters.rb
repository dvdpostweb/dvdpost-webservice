class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :filters do |t|
      t.references :customer
      t.string :search_term
      t.string :view_mode
      t.integer :actor_id
      t.integer :category_id
      t.integer :country_id
      t.integer :director_id
      t.integer :audience_min
      t.integer :audience_max
      t.integer :rating_min
      t.integer :rating_max
      t.integer :year_min
      t.integer :year_max
      t.integer :top_id
      t.integer :theme_id
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
