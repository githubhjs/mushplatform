class Asset < CachedModel
#  has_attachment :storage => :file_system
  attr_accessor :filename, :path, :full_path, :parent_path, :content_type, :created_at
  
  def dir?
    File.directory?(full_path)
  end
  
  def filename_for_index
    filename
  end
  
  def content_type_for_index
    content_type
  end
end
