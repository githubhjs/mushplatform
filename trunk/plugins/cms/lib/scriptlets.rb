require 'mush/scriptlets'
include Mush::Scriptlets

require 'cms_helper'
include CmsHelper

Liquid::Template.file_system = Liquid::LocalFileSystem.new(File.dirname(__FILE__) + "/../app/views")

add_scriptlet_type('type_name' => 'show_html', 'function' => :show_html)
add_scriptlet_type('type_name' => 'list_articles', 'function' => :list_articles)
add_scriptlet_type('type_name' => 'list_channels', 'function' => :list_channels)
add_scriptlet_type('type_name' => 'list_tags', 'function' => :list_tags)
add_scriptlet('name' => 'show_html', 'type_name' => 'show_html')
add_scriptlet('name' => 'tag_cloud', 'type_name' => 'list_tags', 'template' =>"{% for tag in tags %}
<a href=\"/tags/{{tag.name}}\" class=\"{{tag.css_class}}\">{{tag.name}}</a>
{% endfor %}" )
add_scriptlet('name' => 'list_article_by_channel', 'type_name' => 'list_articles', 'template' => 'articles', 'template_type' => 'fs')
