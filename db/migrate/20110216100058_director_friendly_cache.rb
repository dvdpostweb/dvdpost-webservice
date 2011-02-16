class DirectorFriendlyCache < ActiveRecord::Migration
  def self.up
      add_column :directors, :cached_slug, :string
      add_index  :directors, :cached_slug, :unique => true
    end

    def self.down
      remove_column :directors, :cached_slug
    end
end
