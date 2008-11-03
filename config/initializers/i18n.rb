#I18n.default_locale = 'en-US'
#
#LOCALES_DIRECTORY = "#{RAILS_ROOT}/config/locales/"
#locale_files = Dir["#{LOCALES_DIRECTORY}/*.{rb,yml}"]
#LOCALES_AVAILABLE = (locale_files.collect do |locale_file|
#  File.basename(File.basename(locale_file, ".rb"), ".yml")
#end + ['en-US']).uniq
#locale_files.each { |locale_file| I18n.load_translations locale_file }
#I18n.default_locale = 'en-US'
I18n.default_locale = 'en-US'
#I18n.locale         = 'en-US'