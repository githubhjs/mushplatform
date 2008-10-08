class AddLinksImage < ActiveRecord::Migration
  def self.up
    add_column "links", "filename", :string
    add_column "links", "size", :integer
    add_column "links", "content_type", :string
  end

  def self.down
    remove_column "links", "filename"
    remove_column "links", "size"
    remove_column "links", "content_type"
  end
end
