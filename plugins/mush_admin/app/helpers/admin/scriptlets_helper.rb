module Admin::ScriptletsHelper
  include Mush::Scriptlets

  def scriptlet_type_options
    scriptlet_types_registry.keys.collect {|s| [ s, s ] }
  end
  
end
