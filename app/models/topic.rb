class Topic < ActiveRecord::Base

  def last_comment
    TopicComment.find(:first,:conditions => "topic_id=#{self.id}",:order => 'id desc')
  end

  def self.add_comment(topic_id)
    connection.execute("update topics set comment_count = comment_count +1 where id=#{topic_id}")
  end
  
end
