class Blog < ActiveRecord::Base

  belongs_to :category

  has_many   :comments

  

  Drafted_Blogs ,Published_Blogs = 0,1
  
  validates_length_of :title,:in => 5..120,:too_short => "名字不能少于5个字符",:too_long => "标题不能大于120个字符"
  
  validates_length_of :body,:minimum => 20,:too_short => "内容不能少于20个字符"
  
  named_scope :draft_blogs ,:conditions  => "published = #{Drafted_Blogs}",:order => "if_top desc,created_at desc"
  named_scope :publised_blogs,:conditions => "published = #{Published_Blogs}",:order => "if_top desc,created_at desc"
  named_scope :latest,:order => "if_top desc,created_at desc"

  def sticky
    self.if_top = self.if_top^Const::YES
    if save
      if self.if_top == Const::YES
        Blog.connection.execute("update blogs set if_top=#{Const::NO} where if_top=#{Const::YES} and id <> #{self.id}")
      end
      return true
    end
    false
  end
  
  def is_sticky?
    self.if_top == Const::YES
  end

  def is_published?
    !self.published.blank? && self.published == Published_Blogs
  end
  
  def self.batch_publish(ids)
    if ids && ids.size > 0
      Blog.update_all("published = #{Published_Blogs}", "id in (#{ids.join(',')})")
    end
    true
  end
  
 end