require "util/image_util"
class UserProfile < ActiveRecord::Base

  belongs_to :user

  belongs_to :vocation

  after_save :reset_cache

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

  def reset_cache
    Cache.put(UserProfile.profile_cache_key(self.user_id),self)
  end
  
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

  def self.find_by_user_id(user_id)
    cache_key = profile_cache_key(user_id)
    profile =  Cache.get(cache_key)
    unless profile
      profile = find(:first,:conditions => "user_id=#{user_id}") || create(:user_id => user_id,:city => '未知')
      Cache.put(cache_key,profile)      
    end
    profile
  end
  

  def self.profile_cache_key(user_id)
    "record_user_profile_uid#{user_id}"
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
