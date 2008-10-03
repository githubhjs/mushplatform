class AddUserThemeName < ActiveRecord::Migration
  def self.up
    add_column "users", "theme_name", :string
    User.find(:all){|user|
      user.update_attribute(:theme_name => 'default')
    }
  end

  def self.down
    remove_column "users", "theme_name"
  end
end
