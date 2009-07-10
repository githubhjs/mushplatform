class PlayerComment < ActiveRecord::Base

  belongs_to :user

  after_create {|record|
    Player.connection.execute("update players set comment_count = (select count(*) from player_comments where player_id=#{record.player_id}) where user_id=#{record.player_id}")
  }

end
