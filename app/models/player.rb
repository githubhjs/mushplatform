class Player < ActiveRecord::Base

  validates_uniqueness_of :user_id

  def self.calculate_related_entry_count    
    #calculte comment_count
    PlayerComment.class_eval do
      after_create {|record|
        Player.connection.execute("update players set comment_count = (select count(*) from player_comments where player_id=#{record.player_id}) where user_id=#{record.player_id}")
      }
    end

    #calculate blog_count
    Blog.class_eval do
      after_create {|record|
        Player.connection.execute("update players set blog_count = (select count(*) from blogs where user_id=#{record.user_id}) where user_id=#{record.user_id}")
      }
    end

    #calculate photo_count
    Photo.class_eval do
      after_create {|record|
        Player.connection.execute("update players set photo_count = (select count(*) from photos where user_id=#{record.user_id}) where user_id=#{record.user_id}")
      }
    end

    #calculate vote_count
    ActiveVote.class_eval do
      after_create {|record|
        Player.connection.execute("update players set vote_count = (select count(*) from active_votes where user_id=#{record.user_id}) where user_id=#{record.user_id}")
      }
    end
    
  end

  calculate_related_entry_count

  def player_url
    "/#{self.user_name}/active"
  end

  def space_url
    "http://#{self.user_name}.#{Domain_Name}"
  end

  def blog_url
    "#{space_url}/manage/blogs"
  end

  def photo_url
    "#{space_url}/manage/photos"
  end

  def user_profile
    UserProfile.find_by_user_id(self.user_id)
  end
  
end

