require 'rubygems'
require 'RMagick'
require 'net/http'
require 'base64' 
require 'fileutils'
module ImageUtil
  
  class << self
    #process the img to the sepcial size
    def do_image(img,max_size,if_enlarge=false)
      img.trim!
      real_cols,real_rows = img.columns,img.rows
      img.change_geometry(max_size) do |cols,rows,image|
        min_scale = [cols.to_f/real_cols,rows.to_f/real_rows].min
        if if_enlarge 
          return image.resize(min_scale)
        elsif  cols < real_cols or rows < real_rows    
          return image.resize(min_scale)
        end
      end  
    end
  
    #resize the img and will border image when the image's size 
    #is small then you want
    def resize_image(old_img,max_size)
      img= old_img.trim
      real_cols,real_rows = img.columns,img.rows
      img.change_geometry(max_size) do |cols,rows,image|
        min_scale = [cols.to_f/real_cols,rows.to_f/real_rows].min
        new_image = image
        if  cols < real_cols or rows < real_rows    
          new_image = image.resize(min_scale)
        end
        return new_image
        #new_cols,new_rows = new_image.columns,new_image.rows
        #return new_image.border(cols-new_cols,rows-new_rows,'white')
      end
           
    end
    
    
    def create_image(input,path,max_size)
      begin
        FileUtils.makedirs(path) unless File.directory?(File.dirname(path))
        image = Magick::Image.from_blob(input).first
        image = resize_image(image,max_size)
        image.write(path)
      rescue Exception => e
        return false
      end
      return true
    end
    
    def save_image(image,path)
      begin
        FileUtils.makedirs(path) unless File.directory?(File.dirname(path))
        Magick::Image::read_inline(Base64.b64encode(image.read)).first.write(path)
      rescue Exception => e
        raise "#{e.message}"
        return false
      end
      return true
    end
    
    def fetch_and_create_image(from_url,to_path)
      return ture if from_url.blank?
      result = begin
        response = Net::HTTP.get_response(URI.parse(from_url))
        img = response.nil? ?  nil : Magick::Image.from_blob(response.read_body).first 
        unless img.nil?
          FileUtils.makedirs(File.dirname(to_path)) unless File.directory?(File.dirname(to_path))
          img.write(to_path)
          true
        else
          false
        end       
      rescue Exception => e
        false        
      end
      return result
    end
    
    #extract image's postfix,witch is the format of 
    #the special image
    def extract_image_format(img_url)
      format = img_url.scan(/.jpg|.gif|.png/).first if img_url
      return format || '.jpg'
    end
    
  end
 
end