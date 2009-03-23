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
      footstep.content = footstep.content.gsub(/href=(?:"|')([^'""]*)(?:"|')/) do |match|
        path = match.scan(/(?:\/[^\/]*){2}$/).first
        entry_id = path.scan(/\d+/).first       
        entry = klass.find_by_id(entry_id)
        entry ? "href='#{entry.user.space_url}#{path}'" : "href='#'"
      end
      footstep.save
    end
    start += each_loop_count
  end
end
#      title = footstep.content.scan(/<a\s+href="[^"]*">(.*?)<\/a>/).first.first
#      footstep.content = footstep.content.gsub(/href='([^']*)'/,"href='#{footstep.user.space_url}#{'\1'}'")