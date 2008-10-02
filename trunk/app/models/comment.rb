class Comment < ActiveRecord::Base

  belongs_to :blog

  named_scope :latest_comments, lambda { |user_id|
    { :conditions => { :user_id => user_id },:order => "created_at desc" }
  }

  
  def to_liquid
    self.attributes.stringify_keys
  end
  
end
