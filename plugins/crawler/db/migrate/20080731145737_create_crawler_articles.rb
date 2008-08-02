class CreateCrawlerArticles < ActiveRecord::Migration
  def self.up
    create_table :crawler_articles do |t|
      t.string   :title,:author,:img,:summary
      t.integer  :site_id,:null => false
      t.datetime :created_at,:created_at_site
    end
  end

  def self.down
    drop_table :crawler_articles
  end
end
