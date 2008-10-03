class AddTagsCategory < ActiveRecord::Migration
  def self.up
    add_column "tags", :category, :string
    add_column "tags", :top, :text
    add_column "tags", :bottom, :text
    add_column "tags", :position, :integer
    add_index "tags", :category
  end

  def self.down
    remove_column "tags", :category
    remove_column "tags", :top
    remove_column "tags", :bottom
    remove_column "tags", :position
  end
end
