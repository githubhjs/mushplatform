class Blog < ActiveRecord::Base
  include BlogHelper

  belongs_to :category
  has_many   :comments
  Drafted_Blogs ,Published_Blogs = 0,1
  acts_as_taggable

  attr_accessor :tag_names
  before_create :before_create_tell_category
  #validates_length_of :title,:in => 5..120,:too_short => "名字不能少于5个字符",:too_long => "标题不能大于120个字符"
  
  #validates_length_of :body,:minimum => 20,:too_short => "内容不能少于20个字符"
  
  named_scope :draft_blogs ,:conditions  => "published = #{Drafted_Blogs}",:order => "if_top desc,created_at desc"
  named_scope :publised_blogs,:conditions => "published = #{Published_Blogs}",:order => "if_top desc,created_at desc"
  named_scope :latest,:order => "if_top desc,created_at desc"

  named_scope :day_blogs,lambda { |day,user_id|
    { :conditions => "updated_at >= '#{day}' and updated_at <'#{day.next}' and published = #{Published_Blogs}  and user_id = #{user_id}" ,
      :order => "if_top desc,created_at desc"}
  }
  
  def self.blog_count_by_day(day,user_id)
    count('id', :conditions => "updated_at >= '#{day}' and updated_at < '#{day.next}' and published = #{Published_Blogs}  and user_id = #{user_id} ")
  end

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
  def before_create_tell_category
    if  !self.category_id.blank?  && self.category_id > 0
      Category.add_blog_count(self.category_id)
    end
  end

  def is_sticky?
    self.if_top == Const::YES
  end

  def add_view_count
    Blog.connection.execute("update blogs set view_count = view_count+1 where id=#{self.id}")
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
  
  def tag_names=(t_names)
    self.tag_list = t_names.strip.split(/\s+/).map{|nm|nm.strip}  unless t_names.blank? 
  end

  def tag_names
    self.tag_list.join('  ')
  end

  def self.generate_sql_from_arry(arry)
    arry ? sanitize_sql_array(arry) : ''
  end
  
  def to_liquid
    self.attributes.stringify_keys
  end

  def footstep
    Footstep.create(:user_id => user_id, :app => "BLOG", :content => "创建了一篇博客#{entry_link(self)}")
  end
  
end
Tag.class_eval do 
  def to_liquid
    atts = self.attributes.stringify_keys
    atts['author'] = User.find(user_id).user_name unless author
    atts
  end    
end