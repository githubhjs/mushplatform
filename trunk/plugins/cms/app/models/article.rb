class Article < CachedModel
  #partial_updates = true

  has_many :contents, :dependent => :destroy
  belongs_to :channel
  belongs_to :group
  acts_as_taggable

  named_scope :by_channel, lambda {|id| {:conditions => "channel_id = #{id}", :order => "created_at DESC"}}
  
#  def contents
#    if self.id
#      Content.find(:all, :conditions => "article_id = #{self.id}")
#    else
#      [Content.new]
#    end
#  end

  # Return the count of tag tags in this class
  def self.count_tags(tag)
    tag_conditions = ""
    if tag
      tag_conditions = tag.map { |t| sanitize_sql(["name LIKE ?", t]) }.join(" OR ")
      tag_conditions = "(" + tag_conditions + ") AND"
    end
    count_by_sql("select count(*) FROM tags, taggings WHERE #{tag_conditions} tags.id = taggings.tag_id AND taggable_type = 'Article'")
  end  
  
  def body
    article_body = ""
    article_body = contents[0].body if contents.length > 0
    article_body
  end
  
  def to_liquid
     atts = self.attributes.stringify_keys
     excerpt = atts['excerpt']
     if excerpt or excerpt.empty?
       excerpt = body.gsub(/<.+?>/,'').substr(0,170)
       atts['excerpt'] = excerpt
     end
     atts
  end

  def normal_word(str)
     str.gsub!(/\\&[a-zA-Z]{1,10};/,'')
     str.gsub!(/<[^>]*>/,'')
     str.gsub!(/[(\/>)<]/,'')
  end

end
