class AddChannelContentTemplate < ActiveRecord::Migration
  def self.up
    add_column "channels", :content_template_id, :integer
    Channel.update_all("content_template_id = 3")
  end

  def self.down
    remove_column "channels", :content_template_id
  end
end
