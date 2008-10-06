class AddCommentBlogUserId < ActiveRecord::Migration
  def self.up
    add_column "comments", "blog_user_id", :integer
    Comment.find(:all).each{|comment|
      if blog = comment.blog
        comment.update_attribute(:blog_user_id, blog.user_id)
        STDOUT.print "."
        STDOUT.flush
      end
    }
  end

  def self.down
    remove_column "comments", "blog_user_id"
  end
end
