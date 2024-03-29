require 'digest/sha1'

class User < CachedModel
  
  include CachedExtend

  has_one  :user_profile
  has_many :blogs
  has_many :messages
  has_many :receive_regards,:class_name => 'RegardUser',:foreign_key => 'friend_id'
  has_many :send_regards,:class_name => 'RegardUser',:foreign_key => 'user_id'
  has_many :receive_gifts,:class_name => 'GiftUser',:foreign_key => 'friend_id'
  has_many :send_gifts,:class_name => 'GiftUser',:foreign_key => 'user_id'
  has_many :comments
  has_many :user_votes,:foreign_key => 'voter_id'
  has_many :votes
  has_many :photos
  has_many :user_groups
  has_many :categories
  has_many :footsteps
  has_many :albums
  has_many :visitors
  has_many :receive_invites ,:class_name => "Invite",:foreign_key => 'user_id'
  has_many :send_invites ,:class_name => "Invite",:foreign_key => 'invitor_id'
  has_many :group_members
  has_one  :player
#  has_one  :blog_config
  
  validates_size_of :user_name, :within => 3..60
  validates_length_of :password, :within => 6..40  
  validates_uniqueness_of  :user_name
  validates_uniqueness_of  :email
  validates_confirmation_of :password
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_format_of :user_name, :with => /^[-a-z0-9]+$/
  
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

  def visite(user_id)
    if user_id != self.id  && Visitor.find(:first,:conditions => "visitor_id=#{self.id} and user_id=#{user_id} and created_at >= '#{Date.today.strftime('%Y-%m-%d %H:%M')}'").blank?      
      Visitor.create(:visitor_real_name => self.real_name,:visitor_name => self.user_name,:visitor_id => self.id,:user_id => user_id)
    end
  end

  
  def invite(user_id)    
    return true if Invite.find(:first,:conditions => "invitor_id=#{self.id} and user_id=#{user_id}")
    invite  = Invite.new(:invitor_real_name => self.real_name,:invitor_name => self.user_name,:invitor_id => self.id,:user_id => user_id)
    if invite.save
      Friend.create(:user_id => self.id,:friend_id => user_id)
    end
  end

  def blog_config  
    BlogConfig.find_by_user_id(self.id)
  end
  
  def blog_config=(confg)
    @blog_config = confg
  end

  def user_profile
    UserProfile.find_by_user_id(self.id)
  end

  def real_name
    self.user_profile && !self.user_profile.real_name.blank? ? self.user_profile.real_name : self.user_name
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

  def display_user_name
    real_name.blank? ? user_name : real_name
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

