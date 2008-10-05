class SBlogUser < ActiveRecord::Base
  establish_connection "blog" 
  set_table_name "pw_user"
  set_primary_key "uid"

#  has_many :blogs, :class_name => "Blog", :foreign_key => "owner_id"
#  has_many :blog_entries, :class_name => "BlogEntry", :foreign_key => "user_id"

  def cusername
    user = User.find_by_login(self.username)
    cusername = self.username
    cusername = user.firstname if user.firstname and user.firstname != ''
    cusername
  end

end

class SBlogDomain < ActiveRecord::Base
  establish_connection "blog" 
  set_table_name "pw_domain"
  set_primary_key "uid"
end

class SBlogUserinfo < ActiveRecord::Base
  establish_connection "blog" 
  set_table_name "pw_userinfo"
#  set_primary_key "uid"
end
