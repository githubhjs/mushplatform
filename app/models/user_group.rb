require 'util/image_util'
class UserGroup < ActiveRecord::Base

  Group_Icon_Size = "100x140"

  attr_accessor :uploaded_data
  has_many :photos,:foreign_key => :group_id

#  named_scope :user_groups, lambda { |user_id|
#    { :conditions => { :user_id => user_id } }
#  }

  def self.user_groups(user)
    UserGroup.find_by_sql("select g.* from user_groups g inner join group_members gu on (g.id=gu.group_id and gu.user_id=#{user.id})")
  end

  def is_group_admin?(user)
    self.user_id == user.id
  end

  def self.add_topic_count(group_id)
    self.connection.execute("update user_groups set topic_count = topic_count+1 where id=#{group_id}")
  end

  def self.add_member_count(group_id,count)
    self.connection.execute("update user_groups set member_count = member_count + #{count} where id=#{group_id}")
  end

  def is_in_group?(user)
    is_group_admin?(user) || GroupMember.find(:first,:conditions => {:user_id => user.id,:group_id => self.id})
  end
  
  def self.join(group_id,user)
    if GroupMember.create({:group_id => group_id,:user_id => user.id, :user_name => user.user_name})
     UserGroup.add_member_count(self.id,1)
    end
  end

  def self.remove_member(group_id,user)
    if GroupMember.connection.execute("delete from group_members where group_id=#{group_id} and user_id=#{user.id}")
      UserGroup.add_member_count(self.id,-1)
    end
  end

  def upload_icon
    unless self.uploaded_data.blank?
      begin
        image = Magick::Image::read_inline(Base64.b64encode(self.uploaded_data.read)).first
        if image
          generate_group_icon(image,self.uploaded_data.original_filename)
        end
      rescue Exception => e
      end
    end
  end

  def generate_group_icon(orignal_image,original_filename)
    if orignal_image && thumb_image = ImageUtil.resize_image(orignal_image, Group_Icon_Size)
      img_path,img_url = get_image_path_and_url(original_filename)
      thumb_image.write(img_path)
      self.icon = img_url
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
    "/upload/grouppic/#{self.user_id}"
  end

  def get_image_name
     Time.now.to_i.to_s + rand(10000).to_s
  end
  
end
