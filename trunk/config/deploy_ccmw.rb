require 'erb'

set :application, "ccmw"
set :repository,  "http://mushplatform.googlecode.com/svn/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/data/projects/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :subversion
set :user, "root"

role :app, "www.ccmw.net"
role :web, "www.ccmw.net"
role :db,  "www.ccmw.net", :primary => true

after "deploy:setup", "db:create_database_yml"
after "deploy:update_code", "db:symlink_database_yml"
after "deploy:symlink", "deploy:change_owner" 
after "deploy:svn_update", "deploy:restart" 

namespace "db" do
  
  desc "Create database.yml in shared/config" 
  task :create_database_yml do
    database_configuration = ERB.new <<-EOF
  base: &base
    adapter: mysql
    socket: /var/run/mysqld/mysqld.sock
    host: localhost
    username: root
    password: 
    

  development:
    database: #{application}_mush
    <<: *base

  test:
    database: #{application}_mush_test
    <<: *base

  production:
    database: #{application}_mush
    <<: *base

  shadowfox:
    database: ccmw_v2
    <<: *base
  EOF

    run "mkdir -p #{deploy_to}/#{shared_dir}/config" 
    put database_configuration.result, "#{deploy_to}/#{shared_dir}/config/database.yml" 
  end

  desc "Link in the production database.yml" 
  task :symlink_database_yml do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml" 
    run "ln -nfs #{deploy_to}/#{shared_dir}/vendor/rails #{release_path}/vendor/rails" 
    run "ln -nfs #{deploy_to}/#{shared_dir}/assets #{release_path}/public/assets" 
  end

end

namespace :deploy do
  desc "Set the proper permissions for directory"
  task :change_owner do
    run "chown www-data:www-data #{current_path} -R"
    run "chown www-data:www-data #{release_path} -R"
  end

  task :restart, :roles => :web do
    run "/etc/init.d/lighttpd restart &"
  end
  
  task :svn_update, :roles => :web do
    run "#{current_path}/script/update #{current_path}"
  end
end
