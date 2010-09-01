class RenameMovieSourceUrlToFilename < ActiveRecord::Migration
  def self.up
    rename_column :movies, :source_url, :filename
  end

  def self.down
    rename_column :movies, :filename, :source_url
  end
end
