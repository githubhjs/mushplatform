class Comment < ActiveRecord::Base

  belongs_to :blog

  #validates_length_of :title,:in => 1..120,:too_short => "名字不能少于1个字符",:too_long => "标题不能大于120个字符"
  #validates_length_of :body,:minimum => 5,:too_short => "内容不能少于5个字符"
  
  named_scope :latest_comments, lambda { |user_id|
    { :conditions => { :blog_user_id => user_id },:order => "created_at desc" }
  }

  
  def to_liquid
    atts = self.attributes.stringify_keys
    atts['author'] = 'guest' if self.user_id == 0
    atts['title'] = atts['body'].substr(0,12) if self.title.length == 0
    atts
  end
  
end
