class VoteOption < ActiveRecord::Base

  def vote_count
    @vote_count ||= (UserVote.count(:conditions => "vote_value=#{self.id}") || 0)
  end

  def vote_rate(all_count,vote_ct=nil)
    vote_ct ||= vote_count
    all_count = [all_count,1].max
    "%.0f"  %   ((vote_ct.to_f/all_count)*100)
  end
  
end
