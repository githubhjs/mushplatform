# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

ActiveSupport::Dependencies.load_once_paths.clear

require 'acts_as_taggable'
require 'technoweenie/attachment_fu'
Dir[File.dirname(__FILE__) + '/technoweenie/attachment_fu/backends/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/technoweenie/attachment_fu/processors/*.rb'].each { |f| require f }