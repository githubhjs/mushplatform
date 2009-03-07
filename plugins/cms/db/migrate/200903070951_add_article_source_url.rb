class AddArticleSourceUrl < ActiveRecord::Migration
  def self.up
    add_column "articles", :source_url, :string
  end

  def self.down
    remove_column "articles", :source_url
  end
end
