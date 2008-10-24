# To change this template, choose Tools | Templates
# and open the template in the editor.

class SidebarUser < ActiveRecord::Base
  
  set_table_name :sidebars
  
  #validates_uniqueness_of :sidebar_id, :scope => :user_id

  serialize :settings, Hash
  
  named_scope :user_sidebars, lambda { |user_id|
    { :conditions => { :user_id => user_id },:order => "bar_index " }
  }
  
  def self.max_bar_index(user_id)
    SidebarUser.maximum('bar_index',:conditions => {:user_id => user_id})
  end

  def self.min_bar_index(user_id)
    SidebarUser.minimum('bar_index',:conditions => {:user_id => user_id})
  end
  
  def self.create_default_sidebars(user_id)
     SidebarUser.create(:sidebar_id => 'category', :bar_name => "日志分类", :description => "显示日志分类", :user_id => user_id, :bar_index => 1)
     SidebarUser.create(:sidebar_id => 'search', :bar_name => "搜索", :description => "搜索日志", :user_id => user_id, :bar_index => 2)
     SidebarUser.create(:sidebar_id => 'latest_article', :bar_name => "最新文章", :description => "最新文章列表", :user_id => user_id, :bar_index => 3)
     SidebarUser.create(:sidebar_id => 'latest_comments', :bar_name => "最新评论", :description => "显示最新的评论", :user_id => user_id, :bar_index => 4)
     SidebarUser.create(:sidebar_id => 'archives', :bar_name => "归档列表", :description => "按照日期归档文章", :user_id => user_id, :bar_index => 5)
     SidebarUser.create(:sidebar_id => 'static', :bar_name => "友情链接", :description => "自由添加任意内容", :user_id => user_id, :bar_index => 6)
     SidebarUser.create(:sidebar_id => 'rss', :bar_name => "Rss", :description => "此功能可以让别人方便订阅您的博客", :user_id => user_id, :bar_index => 7)
  end  
end
