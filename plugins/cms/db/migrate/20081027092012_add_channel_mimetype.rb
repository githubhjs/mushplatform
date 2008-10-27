class AddChannelMimetype < ActiveRecord::Migration
  def self.up
    add_column "channels", "mimetype", :string
  end

  def self.down
    remove_column "channels", "mimetype"
  end
end
