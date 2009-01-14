class Message < ActiveRecord::Base

   validates_presence_of :title, :message => "标题不能为空"
   validates_presence_of :content, :message => "内容不能为空"

   def to_liquid
    self.attributes.stringify_keys
  end
end
