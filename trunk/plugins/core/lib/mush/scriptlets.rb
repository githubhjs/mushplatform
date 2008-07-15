module Mush
  module Scriptlets
    @@registry = {}

    def add_scriptlet(name, instance, function, template = nil)
      @@registry[name] = Scriptlet.new(name, instance, function, template) unless @@registry[name]
    end

    def remove_scriptlet(name)
      @@registry.delete(name)
    end

  end
end
