class RegardUser < ActiveRecord::Base

  def regard
    @regard ||= Regard.find(self.regard_id)
  end

  def friend
    @friend ||= User.find(self.friend_id)
  end

  def owner
    @owner ||= User.find(self.user_id)
  end

end
