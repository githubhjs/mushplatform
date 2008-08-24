class CreateGroupRoles < ActiveRecord::Migration
  def self.up
    create_table :group_roles, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer :group_id,:role_id ,:null => false
    end
  end

  def self.down
    drop_table :group_roles
  end
end
