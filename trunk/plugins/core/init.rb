require 'mush'

Mush.init

require 'mush/template/liquid_template'
require 'mush/template/liquid_document'
Liquid::Document.send :include, Mush::Template::Document