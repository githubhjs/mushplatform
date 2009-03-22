class Invite < ActiveRecord::Base

  belongs_to :user

  def space_url
    "http://#{self.invitor_name}.#{Domain_Name}"
  end


  def accept
    if update_attribute(:status,1)
      return true if Friend.find(:first,:conditions => {:user_id => self.user_id,:friend_id => self.invitor_id})
      Friend.create(:user_id => self.user_id,:friend_id => self.invitor_id)
    end
  end

  def accept?
    self.status == 1
  end
  
end
