class Blog < ActiveRecord::Base

  belongs_to :category

  has_many   :comments

  named_scope :latest,:order => "if_top desc,created_at desc"

  Drafted_Blogs ,Published_Blogs = 0,1
  
  validates_length_of :title,:in => 5..120,:too_short => "名字不能少于5个字符",:too_long => "标题不能大于120个字符"
  
  validates_length_of :body,:minimum => 20,:too_short => "内容不能少于20个字符"
  
end
