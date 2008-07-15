require 'mush/scriptlet'
require "mush/extension"

require 'mush/template/template'
require 'mush/template/document'

Liquid::Document.send :include, Mush::Template::Document
#ActionView::Base.class_eval { include Mush::ScriptletViewHelper }