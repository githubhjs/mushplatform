class Asset < ActiveRecord::Base
  has_attachment :storage => :file_system
  
  def filename_for_index
    filename
  end
  
  def content_type_for_index
    content_type
  end
end
