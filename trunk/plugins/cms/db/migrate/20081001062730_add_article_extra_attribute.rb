class AddArticleExtraAttribute < ActiveRecord::Migration
  def self.up
    change_column "articles", :status, :boolean, :default => true
    add_column "articles", :top, :boolean, :default => false
    add_column "articles", :sticky, :boolean, :default => false
  end

  def self.down
    remove_column "articles", :top
    remove_column "articles", :sticky
  end
end
