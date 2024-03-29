class Front::EditorsController < ApplicationController  
  skip_before_filter :verify_authenticity_token  
  # 上传图片  
  def upload_editor_image
    base_path = "#{File.expand_path(RAILS_ROOT)}/public/assets/blog/images"
    file = params[:imgfile]  
    filename = params[:imgfile].original_filename.split('.').reverse    
    #filename = Time.now.strftime("%Y%m%d%H%M%S")  + rand(10000).to_s + "." + filename[0]
    filename = generate_filename(base_path, filename[0])
    File.open("#{base_path}/#{filename}", "wb") do |f|
      f.write(file.read)          
    end
    render :text => "<script>window.parent.LoadIMG('/assets/blog/images/#{filename}')</script>"  
  rescue  Exception => e
    render :text => "<script>window.parent.alert('您上传的图片无效或者损坏！#{e}');window.parent.divProcessing.style.display='none'; </script>"  
  end  
       
  # 上传附件  
  def upload_editor_attach
    base_path = "#{File.expand_path(RAILS_ROOT)}/public/assets/blog/files"
    file = params[:attach]  
    filename = params[:attach].original_filename.split('.').reverse
    #filename = Time.now.strftime("%Y%m%d%H%M%S") + rand(10000).to_s + "." + filename[0]
    filename = generate_filename(base_path, filename[0])
    File.open("#{base_path}/#{filename}", "wb") do |f|
      f.write(file.read) 
    end        
    render :text => "<script>window.parent.LoadAttach('/assets/blog/files/#{filename}')</script>"  
  rescue  
    render :text => "<script>window.parent.alert('您上传的附件无效或者损坏！');window.parent.divProcessing.style.display='none'; </script>"  
  end  
       
  def download_attach  
    send_file params[:path]  
  rescue  
    render :text => "对不起，改附件已经损坏，无法下载！"  
  end

  def generate_filename(base_path, extension)
    now = Time.now
    sub_dir = "#{Time.now.strftime("%Y")}/#{Time.now.strftime("%m")}/#{Time.now.strftime("%d")}"
    dir = "#{base_path}/#{sub_dir}"
    FileUtils.mkpath(dir) unless File.exists?(dir)
    "#{sub_dir}/#{now.to_i}#{now.usec}#{Process.pid}.#{extension}"
  end
end  