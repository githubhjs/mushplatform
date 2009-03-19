class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index "blogs", :user_id
    add_index "blogs", :published
    add_index "blogs", :collected
    add_index "comments", :blog_user_id
    add_index "comments", :blog_id
    add_index "blog_configs", :user_id
    add_index "scriptlets", :name
    add_index "articles", :category_id
  end

  def self.down
    remove_index "blogs", :user_id
    remove_index "blogs", :published
    remove_index "blogs", :collected
    remove_index "comments", :blog_user_id
    remove_index "comments", :blog_id
    remove_index "blog_configs", :user_id
    remove_index "scriptlets", :name
    remove_index "articles", :category_id
  end
end
