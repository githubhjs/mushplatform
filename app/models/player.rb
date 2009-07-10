class Player < ActiveRecord::Base

  validates_uniqueness_of :user_id

  def player_url
    "/#{self.user_name}/active"
  end

  def space_url
    "http://#{self.user_name}.#{Domain_Name}"
  end

  def blog_url
    "#{space_url}/blogs"
  end

  def photo_url
    "#{space_url}/photos"
  end

  def user_profile
    UserProfile.find_by_user_id(self.user_id)
  end
  
end

