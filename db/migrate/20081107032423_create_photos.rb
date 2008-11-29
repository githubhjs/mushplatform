class CreatePhotos < ActiveRecord::Migration
  
  def self.up
    create_table :photos do |t|
      t.string   :title,:tags
      t.text     :description
      t.string   :orignal_link,:mid_link,:thumbnail_link, :null => false
      t.integer  :shared,:default => Photo::Shared_Yes
      t.integer  :user_id,:default => 0
    end
  end

  def self.down
    drop_table :photos
  end
  
end
