class Comment < ActiveRecord::Base

  belongs_to :blog
  belongs_to :user

  #validates_length_of :title,:in => 1..120,:too_short => "名字不能少于1个字符",:too_long => "标题不能大于120个字符"
  validates_length_of :body,:minimum => 5,:too_short => "内容不能少于5个字符"
  
  named_scope :latest_comments, lambda { |user_id|
    { :conditions => { :blog_user_id => user_id },:order => "created_at desc" }
  }

  def realtitle
    if title and title.length == 0
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
  
end
