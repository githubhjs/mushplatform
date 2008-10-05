class SBlogEntry < ActiveRecord::Base
  establish_connection "blog" 
  self.inheritance_column = ""
  set_table_name "pw_items"
  set_primary_key "itemid"

  belongs_to :blog_user, :class_name => "SBlogUser", :foreign_key => "uid"
  has_one :blog_category, :class_name => "SBlogCategory", :foreign_key => "cid"
  has_one :text, :class_name => "SBlogEntryText", :foreign_key => "itemid"
  has_many :comments, :class_name => "SBlogComment", :foreign_key => "itemid"

  def blog_category_mapping
    { 1 => 21, 3 => 13, 4 => 14, 5 => 15, 6 => 16, 7 => 17, 8 => 18, 9 => 19, 10 => 20}
  end
  
end

