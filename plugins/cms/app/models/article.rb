class Article < ActiveRecord::Base
  partial_updates = true

  has_many :contents, :dependent => :destroy
  belongs_to :channel
  acts_as_taggable

  named_scope :by_channel, lambda {|id| {:conditions => "channel_id = #{id}", :order => "created_at DESC"}}

  def body
    article_body = ""
    article_body = contents[0].body if contents.length > 0
    article_body
  end
  
  def to_liquid
     atts = self.attributes.stringify_keys
     atts['permalink'] = id unless permalink
     atts
  end   
end
