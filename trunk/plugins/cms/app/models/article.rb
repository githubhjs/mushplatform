class Article < ActiveRecord::Base
  partial_updates = true
  belongs_to :channel
  named_scope :by_channel, lambda {|id| {:conditions => "channel_id = #{id}", :order => "created_at DESC"}}

  def to_liquid
     self.attributes.stringify_keys
  end   
end