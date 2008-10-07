class CreateBlogConfigs < ActiveRecord::Migration
  def self.up
    create_table :blog_configs, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer  :user_id,:null => false
      t.string   :blog_name
      t.integer  :blog_perpage,:default => MySpaceController::Blog_Count_PerPage
      t.integer  :comment_perpage,:default => MySpaceController::Comment_Count_PerPage
      t.string   :theme_name,:default => Theme::Default_Theme_Name
      t.string   :announcement
    end
  end

  def self.down
    drop_table :blog_configs
  end
end
