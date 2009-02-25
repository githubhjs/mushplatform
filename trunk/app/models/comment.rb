class Comment < ActiveRecord::Base

  include BlogHelper

  belongs_to :blog
  belongs_to :user

  #validates_length_of :title,:in => 1..120,:too_short => "名字不能少于1个字符",:too_long => "标题不能大于120个字符"
  validates_length_of :body,:minimum => 5,:too_short => "内容不能少于5个字符"
  
  named_scope :latest_comments, lambda { |user_id|
    { :conditions => { :blog_user_id => user_id },:order => "created_at desc" }
  }

  def realtitle
    if title.blank?
      (!body.blank? and body.length >= 12) ? body.substr(0,12) : body
    else
      title
    end
  end
  
  def to_liquid
    atts = self.attributes.stringify_keys
    atts['author'] = 'guest' if self.user_id == 0
    atts['title'] = realtitle
    atts
  end

  def footstep_link
    "<a href='#{self.user.space_url}/entry/#{blog.id}'>#{realtitle}</a>"
  end

 def footstep
    Footstep.create(:user_id => self.user_id, :app => "COMMENT", :content => "发表了一个评论#{footstep_link}")
 end
 
end
