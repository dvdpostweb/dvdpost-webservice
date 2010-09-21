class FaqOrder < ActiveRecord::Migration
  def self.up
    add_column :faqs, :ordered, :integer
  end

  def self.down
    remove_column :faqs, :ordered
  end
end
