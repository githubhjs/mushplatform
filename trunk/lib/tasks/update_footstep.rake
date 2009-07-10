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
task :init_active_player  => :environment do
  ['guaguagua','xiao-fox','feichidejinglin','popingjazz','liangshuyan',
    'pink-coffee','wangjing','lucyhu830','supergirl','wangxin842001'
  ].each do |user_name|
    if user = User.find_by_user_name(user_name)
      player = Player.new(:user_id => user.id,:user_name => user.user_name,
        :real_name => user.real_name)
      player.blog_count  = user.blogs.count
      player.photo_count = user.photos.count
      player.user_type   = user.user_type
      player.save
    end
  end
end

task :active_group_player  => :environment do
  user_ids = []
  ['sz10000','gy10000','otisccc','wz10000','95522','guilinzls','huihuang2007','hichina',
    '95teleweb','95561','dhlcsd','haier-callcenter','citic','hz10000','sd95519','nm165','neworiental',
    'alipaycallcente','sinacc','sndakf','fundertech'
  ].each do |user_name|
    if user = User.find_by_user_name(user_name)
      player = Player.new(:user_id => user.id,:user_name => user.user_name,
        :real_name => user.real_name)
      player.blog_count  = user.blogs.count
      player.photo_count = user.photos.count
      player.user_type   = user.user_type
      player.save
      user_ids << user.id
    end
  end
  User.connection.execute("update users set user_type=1 where id in (#{user_ids.join(',')})") unless user_ids.blank?
end

task :modify_group_player  => :environment do
  user_ids = []
  ['sz10000','gy10000','otisccc','wz10000','95522','guilinzls','huihuang2007','hichina',
    '95teleweb','95561','dhlcsd','haier-callcenter','citic','hz10000','sd95519','nm165','neworiental',
    'alipaycallcente','sinacc','sndakf','fundertech'
  ].each {|user_name| 
    if user = User.find_by_user_name(user_name)
       user_ids << user.id
    end
  }
  User.connection.execute("update players set user_type=1 where user_id in (#{user_ids.join(',')})") unless user_ids.blank?
end

task :update_player_real_name  => :environment do
  Player.connection.execute("update players set real_name=(select real_name from user_profiles where user_profiles.user_id=players.user_id)")
end