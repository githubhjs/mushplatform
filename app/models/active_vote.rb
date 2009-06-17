class ActiveVote < ActiveRecord::Base

  Vote_Interval = 30

   def self.should_vote_agin?(ip,user_id)
     first(:conditions => ["user_id=#{user_id} and ip=?  and created_at >= date_sub(now() , INTERVAL #{Vote_Interval} minute)",ip],:order => 'id desc').nil?
   end

end
