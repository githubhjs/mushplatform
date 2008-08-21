class ThemesController < ApplicationController

  def index
    @themes = Theme.find(:all)
    @themes.each do |theme|
      theme.description_html = TextFilter.filter_text(this_blog, theme.description, nil, [:markdown,:smartypants])
    end
    @active = this_blog.current_theme
  end

  def preview
    send_file "#{Theme.themes_root}/#{params[:theme]}/preview.png", :type => 'image/png', :disposition => 'inline', :stream => false
  end

  def switchto
    this_blog.theme = params[:theme]
    this_blog.save
    redirect_to :action => 'index'
    zap_theme_caches
  end

  def editor
    case params[:type].to_s
    when "stylesheet"
      path = this_blog.current_theme.path + "/stylesheets/"
      if params[:file] =~ /css$/
        filename = params[:file]
      else
        flash[:error] = "You are not authorized to open this file"
        return
      end
    when "layout"
      path = this_blog.current_theme.path + "/layouts/"
      if params[:file] =~ /rhtml$|erb$/
        filename = params[:file]
      else
        flash[:error] = "You are not authorized to open this file"
        return
      end
    end

    if path and filename
      if File.exists? path + filename
        if File.writable? path + filename
          case request.method
          when :post
            theme = File.new(path + filename, "r+")
            theme.write(params[:theme_body])
            theme.close
            flash[:notice] = "File saved successfully"
            zap_theme_caches
          end
        else
          flash[:notice] = "Unable to write file"
        end
        @file = ""
        file = File.readlines(path + filename, "r")
        file.each do |line|
          @file << line
        end
      end
    end
  end

  protected

  def zap_theme_caches
    FileUtils.rm_rf(%w{stylesheets javascript images}.collect{|v| page_cache_directory + "/#{v}/theme"})
  end
end

#class ThemesController < ApplicationController
#  
#  session :off  
#       
#  def stylesheets  
#    render_theme_item(:stylesheets, params[:filename], 'text/css; charset=utf-8')  
#  end  
#       
#  def javascript  
#    render_theme_item(:javascript, params[:filename], 'text/javascript; charset=utf-8')  
#  end  
#      
#  def images  
#    render_theme_item(:images, params[:filename])  
#  end  
#      
#  def error  
#    render :nothing => true, :status => 404  
#  end  
#      
#  private  
#      
#  def render_theme_item(type, file, mime = nil)  
#    mime ||= mime_for(file)  
#    if file.split(%r{[\\/]}).include?("..")  
#      return (render :text => "Not Found", :status => 404)  
#    end  
#      
#    src = @@stored_theme.path + "/#{type}/#{file}"  
#    return (render :text => "Not Found", :status => 404) unless File.exists? src  
#      
#    if perform_caching  
#      dst = "/#{page_cache_directory}/#{type}/theme/#{file}"  
#      FileUtils.makedirs(File.dirname(dst))  
#      FileUtils.cp(src, "#{dst}.#{$$}")  
#      FileUtils.ln("#{dst}.#{$$}", dst) rescue nil  
#      FileUtils.rm("#{dst}.#{$$}", :force => true)  
#    end  
#      
#    send_file(src, :type => mime, :disposition => 'inline', :stream => true)  
#  end  
#      
#  def mime_for(filename)  
#    case filename.downcase  
#    when /\.js$/  
#      'text/javascript'  
#    when /\.css$/  
#      'text/css'  
#    when /\.gif$/  
#      'image/gif'  
#    when /(\.jpg|\.jpeg)$/  
#      'image/jpeg'  
#    when /\.png$/  
#      'image/png'  
#    when /\.swf$/  
#      'application/x-shockwave-flash'  
#    else  
#      'application/binary'  
#    end  
#  end  
#      
#end 
