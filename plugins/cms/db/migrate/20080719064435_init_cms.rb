class InitCms < ActiveRecord::Migration
  def self.up
    create_table "channels", :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string :name, :null => false
      t.string :permalink
      t.text :body
      t.integer :lft, :rgt
      t.integer :parent_id, :template_id
      t.integer :article_template_id,:content_template_id
      t.integer :channels_count, :default => 0
      t.timestamps
    end
    Channel.update_all("content_template_id = 3,article_template_id = 2")
    add_index "channels", :name
    add_index "channels", :permalink
    add_index "channels", :parent_id
    index = Channel.create(:name => 'index', :permalink => '/', :body => '[[list_article_by_channel]]', :template_id => 1)
#    index.add_child(news = Channel.create(:name => 'news', :permalink => '/news', :template_id => 1))
#    index.add_child(vendors = Channel.create(:name => 'vendors', :permalink => '/vendors'))
#    news.add_child(Channel.create(:name => 'general', :permalink => '/news/general', :template_id => 1))
#    news.add_child(Channel.create(:name => 'special', :permalink => '/news/special', :template_id => 1))
#    vendors.add_child(Channel.create(:name => 'google', :permalink => '/vendors/google'))
#    vendors.add_child(Channel.create(:name => 'yahoo', :permalink => '/vendors/yahoo'))
    
    create_table "templates", :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string :name, :null => false
      t.string :category
      t.text :body
      t.timestamps
    end
    Template.create(:name => 'Layout', :category => 'Layout', :body => '<p>HEADER</p><div>{{content}}</div><p>FOOTER</p>')
    Template.create(:name => 'Article', :category => 'Template', :body => '<h2>{{article.title}}</h2>
<h4>{{article.subtitle}}</h4>
<div>{{article.author}}</div>
<div>{{content.body}}</div>
{% if content.not_first? %}
<a href="{{article | article_permalink}}/page/{{content.previous_page}}">Previous</a>
{% endif %}
Contents
{% if content.not_last? %}
<a href="{{article | article_permalink}}/page/{{content.next_page}}">Next</a>
{% endif %}')
    Template.create(:name => 'Content', :category => 'Template', :body => '')
    
    create_table "articles", :id => false, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer :id
      t.string :title, :null => false
      t.string :display_title, :sub_title, :permalink, :author, :source
      t.text :excerpt
      t.string :redirect_url
      t.integer :status
      t.integer :channel_id
      t.string :cached_tag_list
      t.timestamps
    end
    add_index "articles", :channel_id
    add_index "articles", :permalink
#    Article.create(:title => "I'm a article", :permalink => 'article-one', :author => 'someone', :channel_id => 1)
#    Article.create(:title => "I'm another article", :permalink => 'article-two', :author => 'someone', :channel_id => 1)

    create_table "contents", :id => false, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer :id
      t.string :title
      t.text    :body
      t.integer :page, :default => 1
      t.integer :article_id,:null => false
      t.timestamps
    end
    add_index "contents", [:article_id, :page]
    
    create_table "assets", :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string :name, :null => false
      t.string :type, :content_type, :filename, :path, :category
      t.integer :parent_id, :size, :width, :height
      t.timestamps
    end
  
  end

  def self.down
    drop_table "channels"
    drop_table "templates"
    drop_table "articles"
    drop_table "contents"
    drop_table "assets"
    drop_table "scriptlets"
  end
end
