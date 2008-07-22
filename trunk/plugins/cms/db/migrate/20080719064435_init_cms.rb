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
    index = Channel.create(:name => 'index', :permalink => '/', :body => '[[article_list_by_all(limit=3000)]]', :template_id => 1)
    index.add_child(news = Channel.create(:name => 'news', :permalink => '/news'))
    index.add_child(vendors = Channel.create(:name => 'vendors', :permalink => '/vendors'))
    news.add_child(Channel.create(:name => 'general', :permalink => '/news/gneral'))
    news.add_child(Channel.create(:name => 'special', :permalink => '/news/special'))
    vendors.add_child(Channel.create(:name => 'google', :permalink => '/vendors/google'))
    vendors.add_child(Channel.create(:name => 'yahoo', :permalink => '/vendors/yahoo'))
    
    create_table "templates", :force => true do |t|
      t.string :name, :null => false
      t.string :category
      t.text :body
      t.timestamps
    end
    Template.create(:name => 'Default Layout', :body => '<div>HEADER</div><div>{{content}}</div><div>FOOTER</div>')
    
    create_table "articles", :force => true do |t|
      t.string :title, :null => false
      t.string :url, :subtitle, :display_title, :author, :origin, :image, :file
      t.text :body, :excerpt
      t.integer :status
      t.integer :channel_id
      t.timestamps
    end

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
  end
end
