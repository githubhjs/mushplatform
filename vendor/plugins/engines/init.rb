# Only call Engines.init once, in the after_initialize block so that Rails
# plugin reloading works when turned on
require 'cached_model'
config.after_initialize do
  Engines.init if defined? :Engines
end
