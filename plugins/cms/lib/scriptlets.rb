require 'mush/scriptlets'
include Mush::Scriptlets

require 'cms_helper'
include CmsHelper

Liquid::Template.file_system = Liquid::LocalFileSystem.new(File.dirname(__FILE__) + "/../app/views")

add_scriptlet_type('type_name' => 'show_html', 'function' => :show_html)
add_scriptlet_type('type_name' => 'list_articles', 'function' => :list_articles)
add_scriptlet_type('type_name' => 'list_articles_by_tags', 'function' => :list_articles_by_tags)
add_scriptlet_type('type_name' => 'list_articles_by_tags_category', 'function' => :list_articles_by_tags_category)
add_scriptlet_type('type_name' => 'list_articles_by_block', 'function' => :list_articles_by_block)
add_scriptlet_type('type_name' => 'list_articles_by_search', 'function' => :list_articles_by_search)
add_scriptlet_type('type_name' => 'list_channels', 'function' => :list_channels)
add_scriptlet_type('type_name' => 'list_tags', 'function' => :list_tags)
add_scriptlet('name' => 'show_html', 'type_name' => 'show_html')
add_scriptlet('name' => 'tag_cloud', 'type_name' => 'list_tags', 'template' =>"{% for tag in tags %}
<a href=\"/tags/{{tag.name}}\" class=\"{{tag.css_class}}\">{{tag.name}}</a>
{% endfor %}" )
add_scriptlet('name' => 'list_articles_by_channel', 'type_name' => 'list_articles', 'template' => "{% for article in articles %}
 <li>[{{ article | channel_link_by_article }}] {{ article | article_link }}</li>
{% endfor %}", 'template_type' => 'db')
