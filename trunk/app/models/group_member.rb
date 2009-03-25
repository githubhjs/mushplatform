class GroupMember < ActiveRecord::Base

  validates_uniqueness_of :user_id,:scope => :group_id,:message => "已经加入此群"
  belongs_to :user
end
