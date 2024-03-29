require 'erb'

set :application, "recipe"
set :repository,  "http://mushplatform.googlecode.com/svn/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/data/projects/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :subversion

role :app, "123.103.97.23"
role :web, "123.103.97.23"
role :db,  "123.103.97.23", :primary => true

after "deploy:setup", "db:create_database_yml"
after "deploy:update_code", "db:symlink_database_yml"
#after "deploy:symlink", "deploy:change_owner" 

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
    database: #{application}
    <<: *base

  test:
    database: #{application}_test
    <<: *base

  production:
    database: #{application}
    <<: *base
  EOF

    run "mkdir -p #{deploy_to}/#{shared_dir}/config" 
    put database_configuration.result, "#{deploy_to}/#{shared_dir}/config/database.yml" 
  end

  desc "Link in the production database.yml" 
  task :symlink_database_yml do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml" 
    run "ln -nfs /data/projects/rails #{release_path}/vendor/rails" 
    run "ln -nfs #{deploy_to}/#{shared_dir}/assets #{release_path}/public/assets" 
  end

end

namespace :deploy do
  desc "Set the proper permissions for directory"
  task :change_owner do
    run "sudo chown www-data:www-data #{current_path} -R"
    run "sudo chown www-data:www-data #{release_path} -R"
  end

  task :restart, :roles => :web do
    run "sudo /etc/init.d/lighttpd restart"
  end
end
