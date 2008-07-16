module Mush
  module Scriptlets
    @@scriptlets_registry = {}

    def add_scriptlet(name, function, template = nil)
      @@scriptlets_registry[name] = Scriptlet.new(name, self.method(function), template) unless @@scriptlets_registry[name]
    end

    def remove_scriptlet(name)
      @@scriptlets_registry.delete(name)
    end

  end
end
