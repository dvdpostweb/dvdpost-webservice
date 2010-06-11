class Faq < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.string :name
      t.integer :nb_questions
      t.boolean :active
      t.timestamps
    end
  end

  def self.down
    drop_table :faqs
  end
end
