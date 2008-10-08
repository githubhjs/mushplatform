class Link < CachedModel
  has_attachment :storage => :file_system, :content_type => :image, :path_prefix => 'public/assets/images'
  
  def before_create
    self.category = 'N/A' if self.category.empty?
  end  

  def to_liquid
     self.attributes.stringify_keys
  end  
end
