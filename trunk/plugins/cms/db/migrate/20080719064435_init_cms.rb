class InitCms < ActiveRecord::Migration
  def self.up
    create_table "channels", :force => true do |t|
      t.string :name, :null => false
      t.string :permalink
      t.text :body
      t.integer :lft, :rgt
      t.integer :parent_id, :template_id
      t.integer :channels_count, :default => 0
      t.timestamps
    end
    index = Channel.create(:name => 'index', :permalink => '/', :body => '[[list_article_by_channel(per_page=1)]]', :template_id => 1)
    index.add_child(news = Channel.create(:name => 'news', :permalink => '/news', :template_id => 1))
    index.add_child(vendors = Channel.create(:name => 'vendors', :permalink => '/vendors'))
    news.add_child(Channel.create(:name => 'general', :permalink => '/news/general', :template_id => 1))
    news.add_child(Channel.create(:name => 'special', :permalink => '/news/special', :template_id => 1))
    vendors.add_child(Channel.create(:name => 'google', :permalink => '/vendors/google'))
    vendors.add_child(Channel.create(:name => 'yahoo', :permalink => '/vendors/yahoo'))
    
    create_table "templates", :force => true do |t|
      t.string :name, :null => false
      t.string :category
      t.text :body
      t.timestamps
    end
    Template.create(:name => 'Default Layout', :category => 'Layout', :body => '<div>HEADER</div><div>{{content}}</div><div>FOOTER</div>')
    Template.create(:name => 'Article', :category => 'Template', :body => '<h2>{{article.title}}</h2><h4>{{article.subtitle}}</h4><p>{{article.author}}</p><div>{{article.body}}</div><p>{{article.author}}</p><p>Template from Database</p>')
    
    create_table "articles", :force => true do |t|
      t.string :title, :null => false
      t.string :url, :subtitle, :display_title, :permalink, :author, :origin
      t.text :body, :excerpt
      t.integer :status
      t.integer :channel_id
      t.timestamps
    end
    Article.create(:title => "I'm a article", :permalink => 'article-one', :author => 'someone', :channel_id => 1)
    Article.create(:title => "I'm another article", :permalink => 'article-two', :author => 'someone', :channel_id => 1)

    create_table "assets", :force => true do |t|
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
    drop_table "assets"
    drop_table "scriptlets"
  end
end
