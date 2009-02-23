class Footstep < ActiveRecord::Base

  Footstep_Comment = 'COMMENT'
  Footstep_Blog = 'BLOG'
  Footstep_Vote = 'VOTE'
  Footstep_Photo = 'PHOTO'
  Footstep_Gift  = 'GIFT'
  Footstep_Message = 'MESSAGE'

  belongs_to :user

  def self.friends(user_id)
    # SELECT fs.* FROM footsteps fs, friends fr where fs.user_id = fr.friend_id and fr.user_id = 6695;
    find_by_sql ["SELECT footsteps.* FROM footsteps
                  INNER JOIN friends ON footsteps.user_id = friends.friend_id
                  WHERE friends.user_id = ?", user_id]
  end

end
