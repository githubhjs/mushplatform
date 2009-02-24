ENV['HOME'] = '/home'
# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')

if RUBY_PLATFORM =~ /java/
   require 'rubygems'
   require 'jdbc_adapter'
   RAILS_CONNECTION_ADAPTERS = %w(jdbc)
end

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.plugin_paths += %W( #{RAILS_ROOT}/plugins  #{RAILS_ROOT}/lib/util )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
#  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_domain => '.ccmw.net',
    :session_key => '_mushplatform_session',
    :secret      => '6d420a423d1249c80b5a6ab34523f907a41c910d54b0a3aa8aee41d18debeed8275d1374de6f0879a60c5e944cda227519b2e2a47e8daf020208544e8cf03ffb'
  }

  #config.action_controller.asset_host = "http://www.ccmw.com"
  config.action_controller.page_cache_directory = RAILS_ROOT+"/public/cache/"
  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql
  # Activate observers that should always be running
  config.active_record.observers = :footstep_observer
  config.plugins = [:engines, :liquid, :fckeditor, :core, :authorize, :cms, :all]
  config.gem "calendar_date_select"
end
require File.join(File.dirname(__FILE__), '../vendor/plugins/acts_as_taggable_on_steroids/lib/acts_as_taggable')
USER_SALT="shadowfox"
Domain_Name = 'ccmw.com'
memcache_options = {  
   :c_threshold => 10_000,  
   :compression => true,  
   :debug => false,  
   :namespace => 'cached_model_demo',  
   :readonly => false,  
   :urlencode => false  
 }
CalendarDateSelect.format = :db
CACHE = MemCache.new memcache_options  
CACHE.servers = 'localhost:11211'  


class String
  def substr(start, eend)
    return if( start < 0 or start > eend )
    c = 0
    r = ''
    self.each_char do |x|
      c += 1
      r += x if c > start
      break if c == eend
    end
    r
  end
end
