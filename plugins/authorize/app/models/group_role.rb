class GroupRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :group
end
