class Category < ActiveRecord::Base
  
  validates_uniqueness_of  :name,:message => "类别名已被占用"
  
  validates_length_of       :name, :in => 1..80,:too_short => "名字不能为空",:too_long => "名子不能长于80"

  has_many :blogs
  
  def to_liquid
    self.attributes.stringify_keys
  end

  def self.add_blog_count(id)
    self.connection.execute("update categories set blog_count = blog_count +1 where id=#{id}")
  end

end
