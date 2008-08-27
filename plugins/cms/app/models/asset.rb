class Asset < CachedModel
  has_attachment :storage => :file_system
  
  def dir?
    File.directory?(name)
  end
  
  def filename_for_index
    filename
  end
  
  def content_type_for_index
    content_type
  end
end
