class AddChannelArticleTemplate < ActiveRecord::Migration
  def self.up
    add_column "channels", :article_template_id, :integer
    Channel.update_all("article_template_id = 2")
  end

  def self.down
    remove_column "channels", :article_template_id
  end
end
