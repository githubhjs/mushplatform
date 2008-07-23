require 'digest/sha1'

class User < ActiveRecord::Base
  
  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :login, :email, :password, :password_confirmation, :salt
  validates_uniqueness_of :login, :email
  validates_confirmation_of :password
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  
  
  attr_protected :id, :salt

  attr_accessor :password, :password_confirmation

  def self.authenticate(login, pass)
    u=find(:first, :conditions=>["login = ?", login])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt)==u.hashed_password
    nil
  end  
 
  def authorizations
    @auth ||= self.groups.map{|g|g.own_and_inherint_roles}.flatten
  end
  
  def groups
    Group.user_groups(self)
  end
  
  def self.group_users(group)
    find_by_sql("find u.* from users u inner join group_users gu on (u.id=gu.user_id and gu.group_id=#{group.id})")
  end
  
  def own_roles
    roles = []
    self.groups.each do |u_g| 
      roles += (u_g.groups||[])
      if inherit_group =  u_g.inherit_group
        roles +=  (inherit_group.groups||[])
      end
    end
    roles
  end
  
  def password=(pass)
    @password=pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end

  protected

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end

