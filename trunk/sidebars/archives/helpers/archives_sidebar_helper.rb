module ArchivesSidebarHelper

  Default_Archive_Count = 10

  def self.get_context(option = {})
    counts = Blog.count(:conditions => "published = #{Blog::Published_Blogs} and user_id=#{option[:user_id]}",
      :group => "date_format(created_at,'%Y-%m')",:order => "updated_at desc",:limit => Default_Archive_Count)
    counts.map{|c|Archives.new(c.first,c.last)}
  end

  def self.get_edit_context(options = {})
    {}
  end
  
end

class Archives < Liquid::Block

  attr_accessor :month,:count

  def initialize(month,count)
    @month = month
    @count = count
  end
  def to_liquid
    {'month' => self.month,'count' => self.count}
  end
end