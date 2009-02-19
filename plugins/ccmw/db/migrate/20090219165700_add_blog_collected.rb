class AddBlogCollected < ActiveRecord::Migration
  def self.up
    add_column "blogs", "collected", :boolean, :default => false
    Blog.update_all("collected = 1")
  end

  def self.down
    remove_column "blogs", "collected"
  end
end
