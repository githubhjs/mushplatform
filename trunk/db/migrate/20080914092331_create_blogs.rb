class CreateBlogs < ActiveRecord::Migration
  
  def self.up
    create_table :blogs, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string   :title,:author,:keywords,:text_filter,:permalink
      t.text     :body,:body_html,:extended,:excerpt,:extended_html
      t.integer  :allow_comments,:allow_pings
      t.integer  :published,:default => 0
      t.datetime :created_at,:updated_at
      t.integer  :if_top,:category_id,:default => 0
      t.integer  :user_id,:null => false
      t.integer  :comment_count,:default => 0
    end
  end

  def self.down
    drop_table :blogs
  end
  
end
