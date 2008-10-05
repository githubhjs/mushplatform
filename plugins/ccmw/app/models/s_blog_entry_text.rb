class SBlogEntryText < ActiveRecord::Base
  establish_connection "blog" 
  set_table_name "pw_blog"
  set_primary_key "itemid"
  
  belongs_to :blog_entry, :class_name => "SBlogEntry", :foreign_key => "itemid"
end