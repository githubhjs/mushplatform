class UserVote < ActiveRecord::Base

  belongs_to :user,:foreign_key => 'voter_id'
end
