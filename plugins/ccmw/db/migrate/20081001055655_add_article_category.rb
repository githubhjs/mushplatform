class AddArticleCategory < ActiveRecord::Migration
  def self.up
    create_table "article_categories", :id => false, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer :id
      t.string :name, :category
    end
    add_column "articles", :category_id, :integer
  end

  def self.down
    drop_table "article_categories"
    remove_column "articles", :category_id
  end
end
