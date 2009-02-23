require 'digest/sha1'

class User < CachedModel
  
  has_one  :user_profile
  has_many :blogs
  has_many :messages
  has_many :receive_regards,:class_name => 'RegardUser',:foreign_key => 'friend_id'
  has_many :send_regards,:class_name => 'RegardUser',:foreign_key => 'user_id'
  has_many :receive_gifts,:class_name => 'GiftUser',:foreign_key => 'friend_id'
  has_many :receive_gifts,:class_name => 'GiftUser',:foreign_key => 'user_id'
  has_many :comments
  has_many :user_votes,:foreign_key => 'voter_id'
  has_many :votes
  has_many :photos
  has_many :user_groups
  has_many :categories
  has_many :footsteps
#  has_one  :blog_config
  
  validates_length_of :user_name, :within => 5..40
  validates_length_of :password, :within => 6..40
  validates_presence_of :user_name, :email, :password, :password_confirmation, :salt
  validates_uniqueness_of :user_name, :email
  validates_confirmation_of :password
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "电子邮件格式不正确"  
  
  Status_Valid,Status_Invalid = 0,1
  
  attr_protected :id, :salt

  attr_accessor :password, :password_confirmation,:theme,:blog_config
  
  has_and_belongs_to_many :friends, :class_name => "User", :join_table => "friends", 
                          :foreign_key => 'user_id', :association_foreign_key => 'friend_id'
                           
  def self.authenticate(user_name, pass)
    u=find(:first, :conditions=>["user_name = ?", user_name])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt)==u.hashed_password
    nil
  end  
 
  def blog_config
    @blog_config ||= BlogConfig.find_or_create_by_user_id(self.id)
  end
  
  def blog_config=(confg)
    @blog_config = confg
  end

  def space_url
    "http://#{self.user_name}.#{Domain_Name}"
  end
  
  def authorizations
    @auth ||= self.groups.map{|g|g.own_and_inherint_roles}.flatten
    @auth
  end
  
  def is_friend_with?(other)
   if other
     @friend ||= Friend.find(:first,:conditions => "user_id=#{self.id} and friend_id=#{other.id}")
   else
     nil
   end  
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
      roles += (u_g.roles||[])
      if inherit_group =  u_g.inherit_group
        roles +=  (inherit_group.roles||[])
      end
    end
    roles
  end

  def self.swich_theme(user_id,theme_name)
    #connection.execute("update users set theme_name='#{theme_name}' where id=#{user_id}")
    User.find(user_id).blog_config.update_attribute(:theme_name, theme_name)
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
    Notifications.deliver_forgot_password(self.email, self.user_name, new_pass)
  end

  def to_liquid
    self.attributes.stringify_keys
  end

  protected

  def self.encrypt(pass, salt)
    hashed_password = hashed(pass)
    hashed(salt + hashed_password)
  end
  
  def self.hashed(str)
    Digest::SHA1.hexdigest("#{USER_SALT}--#{str}--}")[0..39]
  end

  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
end

