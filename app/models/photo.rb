require 'util/image_util'
class Photo < ActiveRecord::Base
  
  Shared_Yes,Shared_No = 1,0
  
  Mid_Size,Thumbnail_Size = "100x100","50x50"
  
  Upload_Image_Path = "/upload/pic"
  
  attr_accessor :orignal_image,:user_id
  
  validates_presence_of :orignal_link,:mid_link,:thumbnail_link
  
  before_save :upload_image
  
  def upload_image
    unless self.orignal_image.blank?
      begin
        image = Magick::Image::read_inline(Base64.b64encode(self.orignal_image.read)).first
        if image
          generate_orignal_image(image,self.orignal_image.original_filename)
          generate_mid_image(image,self.orignal_image.original_filename)
          generate_thumb_image(image,self.orignal_image.original_filename)
        end
      rescue Exception => e
      end
    end
  end
  
  def generate_orignal_image(orignal_image,original_filename)
    if orignal_image
      img_path,img_url = get_image_path_and_url(original_filename)
      orignal_image.write(img_path)
      self.orignal_link = img_url
    end
    
  end
  
  def generate_mid_image(orignal_image,original_filename)
    if orignal_image && mid_image = ImageUtil.resize_image(orignal_image, Mid_Size)
      img_path,img_url = get_image_path_and_url(original_filename,'mid')
      mid_image.write(img_path)
      self.mid_link = img_url
    end
  end
  
  def generate_thumb_image(orignal_image,original_filename)
    if orignal_image && thumb_image = ImageUtil.resize_image(orignal_image, Mid_Size)
      img_path,img_url = get_image_path_and_url(original_filename,'mid')
      thumb_image.write(img_path)
      self.thumbnail_link = img_url
    end 
  end
  
  
  def get_image_path_and_url(orignal_name,type='')
    img_path,img_name = "#{Rails_Root}#{get_img_dir}",generate_image_name(orignal_name,type)
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
  
end