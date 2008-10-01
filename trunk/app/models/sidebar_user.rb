# To change this template, choose Tools | Templates
# and open the template in the editor.

class SidebarUser < ActiveRecord::Base
  
  set_table_name :sidebars
  
  validates_uniqueness_of :sidebar_id, :scope => :user_id

  named_scope :user_sidebars, lambda { |user_id|
    { :conditions => { :user_id => user_id },:order => "bar_index desc" }
  }

  def self.max_bar_index(user_id)
      SidebarUser.maximum('bar_index',:conditions => {:user_id => user_id})
  end

  def self.min_bar_index(user_id)
    SidebarUser.minimum('bar_index',:conditions => {:user_id => user_id})
  end
  
end
