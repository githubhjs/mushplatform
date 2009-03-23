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
#      title = footstep.content.scan(/<a\s+href="[^"]*">(.*?)<\/a>/).first.first
#      footstep.content = footstep.content.gsub(/href='([^']*)'/,"href='#{footstep.user.space_url}#{'\1'}'")
      footstep.content = footstep.content.gsub(/href='([^']*)'/) do |match|
        path = match.scan(/(?:\/[^\/]*){2}$/).first
        "href='#{footstep.user.space_url}#{path}'"
      end
      footstep.save
    end
    start += each_loop_count
  end
end
