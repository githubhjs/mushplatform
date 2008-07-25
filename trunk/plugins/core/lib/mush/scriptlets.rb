module Mush
  module Scriptlets
    @@scriptlets_registry = {}
    @@scriptlet_types_registry = {}

    def add_scriptlet(args)
      args[:function] = self.method(args.delete(:function))
#      template = Liquid::Template.file_system.read_template_file(args[:template]) if args[:template_type] == 'fs'
      scriptlet = Scriptlet.find_by_name(args[:name])
      scriptlet = Scriptlet.create(
        :name => args[:name], 
        :scriptlet_type_name => args[:name],
        :template_type => args[:template_type] ? args[:template_type] : 'db',
        :template => args[:template]
      ) unless scriptlet
      @@scriptlets_registry[args[:name]] = scriptlet
      @@scriptlet_types_registry[args[:name]] = ScriptletType.new(args) unless @@scriptlet_types_registry[args[:name]]
    end

    def remove_scriptlet(name)
      @@scriptlets_registry.delete(name)
    end

    def add_scriptlet_type(args)
      args[:function] = self.method(args.delete(:function))
      @@scriptlet_types_registry[args[:name]] = ScriptletType.new(args) unless @@scriptlet_types_registry[args[:name]]
    end

    def remove_scriptlet_type(name)
      @@scriptlet_types_registry.delete(name)
    end
    
    def self.load_all_scriptlets
      migrate_scriptlets
      Scriptlet.find(:all).each{|s|
        @@scriptlets_registry[s.name] = s
      }
    end
    
    def self.migrate_scriptlets
      unless ActiveRecord::Base.connection.table_exists?('scriptlets')
        ActiveRecord::Base.connection.create_table "scriptlets", :force => true do |t|
          t.string :name, :scriptlet_type_name, :template_type
          t.text :template
          t.timestamps
        end
      end
    end

  end
end
