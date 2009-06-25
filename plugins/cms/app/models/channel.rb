class Channel < CachedModel
  acts_as_nested_set :order => "id", :counter_cache => true
  Channel.include_root_in_json = false
  belongs_to :template
  belongs_to :article_template, :class_name => "Template", :foreign_key => "article_template_id"
  belongs_to :content_template, :class_name => "Template", :foreign_key => "content_template_id"
  has_many :articles
  
  def after_find
    @attributes['text'] = name
    @attributes_cache['text'] = name
  end
  
  def before_create
    self.article_template_id = 2
    self.content_template_id = 3
  end
  
  def self.root_nodes
    find(:all, :conditions => 'parent_id IS NULL')
  end

  def self.find_children(start_id = nil)
    start_id.to_i == 0 ? root_nodes : find(start_id).direct_children
  end
  
  def leaf
    unknown? || children_count == 0
  end

  def to_json_with_leaf(options = {})
    self.to_json_without_leaf(options.merge(:methods => :leaf))
  end

  def channel_permalink
    link = permalink.blank?  ? "/channel/#{id}" : permalink
    link == '/' ? '' : link
  end

  alias_method_chain :to_json, :leaf

  def to_liquid
     self.attributes.stringify_keys
  end  
end
