require 'mush/scriptlets'
include Mush::Scriptlets

require 'ccmw_helper'
include CcmwHelper

add_scriptlet_type('type_name' => 'list_articles_by_categories', 'function' => :list_articles_by_categories)
add_scriptlet_type('type_name' => 'list_categories_by_category', 'function' => :list_categories_by_category)
add_scriptlet_type('type_name' => 'list_tags_by_category', 'function' => :list_tags_by_category)
add_scriptlet_type('type_name' => 'list_links_by_category', 'function' => :list_links_by_category)
add_scriptlet_type('type_name' => 'list_image_links_by_category', 'function' => :list_image_links_by_category)
add_scriptlet_type('type_name' => 'focus_images_from_links', 'function' => :focus_images_from_links)
add_scriptlet_type('type_name' => 'list_journals_by_year', 'function' => :list_journals_by_year)
add_scriptlet_type('type_name' => 'years_of_journals', 'function' => :years_of_journals)
#add_scriptlet_type('type_name' => 'list_articles', 'function' => :list_articles)
#add_scriptlet_type('type_name' => 'list_channels', 'function' => :list_channels)
#add_scriptlet_type('type_name' => 'list_tags', 'function' => :list_tags)
#add_scriptlet('name' => 'show_html', 'type_name' => 'show_html')
#add_scriptlet('name' => 'tag_cloud', 'type_name' => 'list_tags', 'template' =>"{% for tag in tags %}
#<a href=\"/tags/{{tag.name}}\" class=\"{{tag.css_class}}\">{{tag.name}}</a>
#{% endfor %}" )
#add_scriptlet('name' => 'list_article_by_channel', 'type_name' => 'list_articles', 'template' => 'articles', 'template_type' => 'fs')
