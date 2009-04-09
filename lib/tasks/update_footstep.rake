require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
desc "update footstep content url"
task :footstep  => :environment  do
  count = Footstep.count
  start,each_loop_count = 0,200
  while (start < count)
    footsteps = Footstep.find(:all,:limit => each_loop_count, :offset => start)
    footsteps.each do |footstep|
      klass = case footstep.app
      when "BLOG"
        Blog
      when "COMMENT"
        Blog
      when "VOTE"
        Vote
      else
      end
      footstep.content = footstep.content.gsub(/href=["']([^'""]*)["']+/) do |match|
        path = $1.scan(/(?:\/[^\/]*){2}$/).first
        entry_id = path.scan(/\d+/).first       
        entry = klass.find_by_id(entry_id)
        entry ? "href='#{entry.user.space_url}#{path}'" : "href='#'"
      end      
      footstep.save
      #      puts footstep.content
    end
    start += each_loop_count
  end
end

task :update_blog_author => :environment do
  count = Blog.count
  start,each_loop_count = 0,200
  while (start < count)
    blogs = Blog.find(:all,:limit => each_loop_count, :offset => start)
    blogs.each do |blog|
      blog.update_attribute(:author,User.find(blog.user_id).real_name)
    end
    start += each_loop_count
  end
end

task :update_comment_author => :environment do
  count = Comment.count
  start,each_loop_count = 0,200
  while (start < count)
    comments = Comment.find(:all,:limit => each_loop_count, :offset => start)
    comments.each do |comment|
      next if comment.user_id.blank? || comment.user_id <= 0
      comment.update_attribute(:author,User.find(comment.user_id).real_name)
    end
    start += each_loop_count
  end
end
#      title = footstep.content.scan(/<a\s+href="[^"]*">(.*?)<\/a>/).first.first
#      footstep.content = footstep.content.gsub(/href='([^']*)'/,"href='#{footstep.user.space_url}#{'\1'}'")