class AddTagsCategory < ActiveRecord::Migration
  def self.up
    add_column "tags", :category, :string
    add_index "tags", :category    
  end

  def self.down
    remove_column "tags", :category
  end
end
