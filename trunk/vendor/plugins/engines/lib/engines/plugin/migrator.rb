# The Plugin::Migrator class contains the logic to run migrations from
# within plugin directories. The directory in which a plugin's migrations
# should be is determined by the Plugin#migration_directory method.
#
# To migrate a plugin, you can simple call the migrate method (Plugin#migrate)
# with the version number that plugin should be at. The plugin's migrations
# will then be used to migrate up (or down) to the given version.
#
# For more information, see Engines::RailsExtensions::Migrations
class Engines::Plugin::Migrator < ActiveRecord::Migrator

  # We need to be able to set the 'current' engine being migrated.
  cattr_accessor :current_plugin

  # Runs the migrations from a plugin, up (or down) to the version given
  def self.migrate_plugin(plugin, version)
    self.current_plugin = plugin
    migrate(plugin.migration_directory, version)
  end
  
  # Returns the current version of the given plugin
  def self.current_version(plugin=current_plugin)
    sm_table = schema_migrations_table_name
    migrated = ActiveRecord::Base.connection.select_values("SELECT version FROM #{sm_table}").map(&:to_i).sort
    migrated.delete_if {|m| !plugin.migrations.include?(m)}
    migrated.last || 0
  end
  
  
end
