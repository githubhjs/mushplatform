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
      footstep.content = footstep.content.gsub(/href='([^']*)'/,"href='#{footstep.user.space_url}#{'\1'}'")
      footstep.save
    end
    start += each_loop_count
  end
end
