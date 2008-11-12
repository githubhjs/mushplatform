class Mfile < CachedModel
  set_table_name "files"
  has_attachment :storage => :file_system
  
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