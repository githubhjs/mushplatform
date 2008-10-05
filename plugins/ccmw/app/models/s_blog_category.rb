class SBlogCategory < ActiveRecord::Base
  establish_connection "blog" 
  set_table_name "pw_categories"
  set_primary_key "cid"

  belongs_to :blog, :class_name => "SBlog", :foreign_key => "cid"

end

#class BlogEntry < ActiveRecord::Base
#  establish_connection = "blog" 
#  set_table_name "pw_blog"
#  set_primary_key "tid"

#  belongs_to :blog_user, :class_name => "BlogUser", :foreign_key => "uid"
#  has_one :blog_category, :class_name => "BlogCategory", :foreign_key => "cid"
#  has_one :text, :class_name => "BlogEntryText", :foreign_key => "tid"
#end


