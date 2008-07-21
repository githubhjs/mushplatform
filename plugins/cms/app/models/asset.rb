class Asset < ActiveRecord::Base
  has_attachment :storage => :file_system, :path_prefix => 'public/files'
end
