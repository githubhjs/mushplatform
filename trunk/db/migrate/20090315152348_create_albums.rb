class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
       t.string  :title ,:null => false
       t.integer :user_id,:null => false
    end
    add_column :photos,:album_id,:integer,:default => 0
  end

  def self.down
    drop_table :albums
    remove_column :photos,:album_id
  end
end
