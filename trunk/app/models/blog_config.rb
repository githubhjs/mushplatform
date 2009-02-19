class BlogConfig < ActiveRecord::Base
  belongs_to :user

  def self.add_view_count(user_id)
    BlogConfig.connection.execute("update blog_configs set view_count = view_count+1 where user_id=#{user_id}")
  end
end
