class GiftUser < ActiveRecord::Base

  validates_presence_of :user_id,:message => "用户id不能为空"
  validates_presence_of :friend_id ,:message => "请选择好友"
  validates_presence_of :gift_id ,:message => "请选择礼物"
  belongs_to :user

#  attr_accessor :friend_name
#
#  def friend_name=(f_name)
#    unless f_name.blank?
#      f_names = f_name.split(',')
#      f_names.each do |friend_name|
#        if user = User.find_by_user_name(friend_name)
#          self.friend_id = user.id
#        end
#      end
#    end
#  end
  
  def gift
    @gift ||= Gift.find(self.gift_id)
  end

  def friend
    @friend ||= User.find(self.friend_id)
  end

  def owner
    @owner ||= User.find(self.user_id)
  end

  def mod_desc
    self.send_mode == 0 ? '悄悄' : '匿名'
  end
end
