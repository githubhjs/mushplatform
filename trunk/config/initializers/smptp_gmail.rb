 require "smtp_tools"
 mailer_config = File.open("#{RAILS_ROOT}/config/mailer.yml")
 mailer_options = YAML.load(mailer_config)
 ActionMailer::Base.delivery_method = :smtp
 ActionMailer::Base.default_charset = "utf-8"
 ActionMailer::Base.smtp_settings = mailer_options  