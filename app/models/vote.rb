class Vote < ActiveRecord::Base

  Only_Man,Only_Woman,Any_Sex = 2,1,0
  Roll_Any_One,Roll_Only_friend = 0,1

  validates_presence_of :title,:message => '主题不能为空'

  attr_accessor :vote_options

  before_create :before_create_by_business

  def before_create_by_business
    self.set_default_expire_time
  end

  def validate
    if self.vote_options.blank?
      errors.add_to_base('请至少填写一个候选项')
    end
  end

  def sex_permite?(user)
    return false unless user
    (self.sex_limit == Only_Man && user.user_profile.sex == Const::Sex_Man)     ||
    (self.sex_limit == Only_Woman && user.user_profile.sex == Const::Sex_Woman) ||
    self.sex_limit == Any_Sex
  end

  def owner
    @owner ||= User.find_by_id(self.user_id)
  end
  
  def roll_permite?(user)
    return false unless user
    self.roll_limt == Roll_Any_One || (self.roll_limt == Roll_Only_friend && @owner.is_friend_with?(user))
  end

  def permite_vote?(user)
    user.id == self.user_id || (roll_permite?(user) && sex_permite?(user))
  end

  def set_default_expire_time
    if self.expire_time.blank?
      self.expire_time = DateTime.now.months_since(1)
    end
  end

  def member_count
    @member_count ||= (UserVote.count(:conditions => "vote_id=#{self.id}")||0)
  end
end
