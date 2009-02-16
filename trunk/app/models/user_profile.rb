require "util/image_util"
class UserProfile < ActiveRecord::Base

  belongs_to :user

  belongs_to :vocation

#  has_attachment :storage => :file_system, :path_prefix => 'public/assets/avatar',
#                 :content_type => :image, :processor => 'Rmagick', :thumbnail_class => :thumbnail,
#                 :thumbnails => { :normal => '120x120>', :small => '50x50>' }
  file_column :avatar, :store_dir => 'assets/avatar', :base_url => 'assets/avatar',
              :magick => { :versions => { :normal => { :size => "120x120>", :crop => "1:1"},
                                          :small => { :size => "50x50>", :crop => "1:1" }
                                        }
                         }

  Company_Nature_Other      =  3
  Company_Nature_User       =  2
  Company_Nature_Suppliers  =  1

  Intrested_Call_Center,Intrested_Client_Manage,Intrested_Data_Buy,Intrested_Server_Buy,Intrested_Other = 1,2,3,4,5
  
  attr_accessor :user_icon
    
  #validates_length_of :city,:minimum => 1,:too_short => "请填写您所在的城市"
  validates_length_of :sex,:minimum => 1,:too_short => "选选择性别"
 
  Image_Size = "100X100"
  
  
  def user_icon=(img)
    unless img.blank?
      img_url,img_path = generate_image_url_and_path(img.original_filename)    
      self.photo = img_url if ImageUtil::create_image(img.read,img_path,Image_Size)
    end
  rescue Exception => e
    return false
  end

  def vocation_name
    (self.vocation_id && self.vocation_id > 0 &&  self.vocation)  ? self.vocation.vocation_name : ''
  end
 
  def generate_image_url_and_path(original_img_name)
    rand_dir,img_name = generate_local_dir,generate_image_name(original_img_name)
    file_path = "#{RAILS_ROOT}/public/images/#{rand_dir}"
    FileUtils.makedirs(file_path) unless File.directory?(file_path)
    #if the new file have existed
    if FileTest::exist?("#{file_path}/#{img_name}")
      format  =  ImageUtil::extract_image_format(img_name)
      img_name = "#{img_name.gsub(format,'').strip}_#{rand(1000)}#{format}"
    end
    return ["/images/#{rand_dir}/#{img_name}","#{file_path}/#{img_name}"]
  end
  
  #generate a rand dir 
  def generate_local_dir
    today = Date.today
    return Digest::MD5.hexdigest("#{today.year}#{today.cweek}")[0,8]
  end
  
  #generate image name with suffix
  def generate_image_name(img_url)
    get_image_name + ImageUtil::extract_image_format(img_url)
  end
  
   #this method should be overwriter
  def get_image_name
    return  Time.now.to_i.to_s + rand(CONST_RAND).to_s
  end
  
  
end
