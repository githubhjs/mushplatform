class UserVote < ActiveRecord::Base

  belongs_to :user,:foreign_key => 'voter_id'
  
  belongs_to :vote
  
  def footstep_link
    "<a href='/votes/#{self.vote_id}'>#{self.vote.title}</a>"
  end

 def footstep
    Footstep.create(:user_id => self.voter_id, :app => Footstep::Footstep_Vote, :content => "参与了#{footstep_link}投票")
 end
 
end
