class CreateMushCrawlers < ActiveRecord::Migration
  def self.up
    create_table :mush_crawlers, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string   :crawler_name,:crawler_path,:null => false
      t.integer  :craw_freq,:null => false 
      t.integer  :status,:default => 0
    end
  end

  def self.down
    drop_table :mush_crawlers
  end
end
