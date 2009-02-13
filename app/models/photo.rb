require 'util/image_util'
class Photo < ActiveRecord::Base
  
  Shared_Yes,Shared_No = 1,0
  
  Mid_Size,Thumbnail_Size,Max_Size = "100x100","50x50","700x525"
  
  Upload_Image_Path = "/upload/pic"
  
  attr_accessor :uploaded_data
  
  validates_presence_of :orignal_link,:mid_link,:thumbnail_link
  
  acts_as_taggable

  before_save :upload_image

  named_scope :user_photos, lambda { |user_id|
    { :conditions => { :user_id => user_id } }
  }
  named_scope :latest_photos, lambda { |user_id|
    { :conditions => { :user_id => user_id },:order => "id desc" }
  }
  def upload_image
    unless self.uploaded_data.blank?
      begin
        image = Magick::Image::read_inline(Base64.b64encode(self.uploaded_data.read)).first
        if image
          generate_image(image,self.uploaded_data.original_filename,:orignal_link)
          generate_image(image,self.uploaded_data.original_filename,:max_link,'max',Max_Size)
          generate_image(image,self.uploaded_data.original_filename,:mid_link,'mid',Mid_Size)
          generate_image(image,self.uploaded_data.original_filename,:thumbnail_link,'thum',Thumbnail_Size)
        end
      rescue Exception => e
#        puts e.message
      end
    end
  end
  
   
  def generate_image(orignal_image,original_filename,column_name,img_type,resize = nil)
    if orignal_image && (resize_img = resize.blank? ? orignal_image  : ImageUtil.resize_image(orignal_image,resize ))
      img_path,img_url = get_image_path_and_url(original_filename,img_type)
      resize_img.write(img_path)
      self.send("#{column_name}=",img_url)
    end 
  end
  
  def get_image_path_and_url(orignal_name,type='')

    img_path,img_name = "#{RAILS_ROOT}/public/#{get_img_dir}",generate_image_name(orignal_name,type)
    FileUtils.makedirs(img_path) unless File.directory?(img_path)
    ["#{img_path}/#{img_name}","#{get_img_dir}/#{img_name}"]
  end
  
  def generate_image_name(img_url,type = '')
    get_image_name + type + ImageUtil::extract_image_format(img_url)
  end
  
  def get_img_dir
    "/upload/pic/#{self.user_id}"
  end
   
  def get_image_name
    @orig_name ||=  Time.now.to_i.to_s + rand(10000).to_s
  end

   def to_liquid
    self.attributes.stringify_keys
  end   
  
end
