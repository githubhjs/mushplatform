class SBlogComment < ActiveRecord::Base
  establish_connection "blog" 
  self.inheritance_column = ""
  set_table_name "pw_comment"
  set_primary_key "id"
  belongs_to :blog_user, :class_name => "SBlogUser", :foreign_key => "authorid"
end