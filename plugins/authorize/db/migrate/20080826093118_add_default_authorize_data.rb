require 'authorize'
class AddDefaultAuthorizeData < ActiveRecord::Migration
  def self.up
    group = Group.create(:group_name => 'admin')
    role = Role.create(:role_name => 'admin', :e_name => 'admin')
    user = User.create(:user_name => 'admin', :email => 'admin@mushplatform.org', :password => '3edc$rfv', :password_confirmation => '3edc$rfv')
    Authorize::AuthManager.auth_group(group,[role])
    Authorize::AuthManager.auth_user(user, [group.id])
  end
  def self.down
  end
end
