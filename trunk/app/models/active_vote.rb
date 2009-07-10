class ActiveVote < ActiveRecord::Base

  Vote_Interval = 30

  after_create {|record|
    Player.connection.execute("update players set vote_count = (select count(*) from active_votes where user_id=#{record.user_id}) where user_id=#{record.user_id}")
  }

  def self.should_vote_agin?(ip,user_id)
    first(:conditions => ["user_id=#{user_id} and ip=?  and created_at >= date_sub(now() , INTERVAL #{Vote_Interval} minute)",ip],:order => 'id desc').nil?
  end

end
