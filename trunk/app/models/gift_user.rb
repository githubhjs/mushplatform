class GiftUser < ActiveRecord::Base
  def gift
    @gift ||= Gift.find(self.gift_id)
  end

  def friend
    @friend ||= User.find(self.friend_id)
  end

  def owner
    @owner ||= User.find(self.user_id)
  end
end
