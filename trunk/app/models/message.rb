class Message < ActiveRecord::Base

  validates_length_of :title,:in => 2..120,:too_short => "标题不能少于5个字符",:too_long => "标题不能大于120个字符"

  validates_length_of :content,:minimum => 20,:too_short => "内容不能少于10个字符"

   def to_liquid
    self.attributes.stringify_keys
  end
end
