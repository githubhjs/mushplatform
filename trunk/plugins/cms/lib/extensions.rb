# require 'app/helper/extension_helper'

module Mush
  module Plugin
    class CmsExtension < Mush::Plugin::Extension
      
      class << self
        def init
          add_extension('admin_main_menu', :add_admin_menu, 1)
          add_extension('one_extension_point', :one_function)
        end
      end
      
    end
  end
end
