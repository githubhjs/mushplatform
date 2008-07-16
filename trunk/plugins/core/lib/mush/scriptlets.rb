module Mush
  module Scriptlets
    @@scriptlets_registry = {}

    def add_scriptlet(args)
      args[:function] = self.method(args.delete(:function))
      @@scriptlets_registry[args[:name]] = Scriptlet.new(args) unless @@scriptlets_registry[args[:name]]
    end

    def remove_scriptlet(name)
      @@scriptlets_registry.delete(name)
    end

  end
end
