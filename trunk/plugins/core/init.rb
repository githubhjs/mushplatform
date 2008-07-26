require 'mush/scriptlet'
require 'mush/scriptlet_type'
require 'mush/scriptlets'

require 'mush/extension'
require 'mush/extension_point'
require 'mush/extension_points'

require 'mush/template/template'
require 'mush/template/document'

Liquid::Document.send :include, Mush::Template::Document

ActionView::Base.class_eval { include Mush::ExtensionPoints }
ActionController::Base.class_eval { include Mush::ExtensionPoints }

Mush::Scriptlets.load_all_scriptlets