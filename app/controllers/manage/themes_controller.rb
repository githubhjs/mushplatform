class Manage::ThemesController <  Manage::ManageController

  def index
    @themes = Theme.find_all_theme
    @active = Theme.find(current_user.theme_name)
  end

  def preview
    
  end

  def switchto
    current_user.theme_name = params[:theme_name]
    current_user.save
    redirect_to :action => 'index'
  end

  #  def editor
  #    case params[:type].to_s
  #    when "stylesheet"
  #      path = this_blog.current_theme.path + "/stylesheets/"
  #      if params[:file] =~ /css$/
  #        filename = params[:file]
  #      else
  #        flash[:error] = "You are not authorized to open this file"
  #        return
  #      end
  #    when "layout"
  #      path = this_blog.current_theme.path + "/layouts/"
  #      if params[:file] =~ /rhtml$|erb$/
  #        filename = params[:file]
  #      else
  #        flash[:error] = "You are not authorized to open this file"
  #        return
  #      end
  #    end
  #
  #    if path and filename
  #      if File.exists? path + filename
  #        if File.writable? path + filename
  #          case request.method
  #          when :post
  #            theme = File.new(path + filename, "r+")
  #            theme.write(params[:theme_body])
  #            theme.close
  #            flash[:notice] = "File saved successfully"
  #            zap_theme_caches
  #          end
  #        else
  #          flash[:notice] = "Unable to write file"
  #        end
  #        @file = ""
  #        file = File.readlines(path + filename, "r")
  #        file.each do |line|
  #          @file << line
  #        end
  #      end
  #    end
  #  end
  #
  #  protected
  #
  #  def zap_theme_caches
  #    FileUtils.rm_rf(%w{stylesheets javascript images}.collect{|v| page_cache_directory + "/#{v}/theme"})
  #  end
end
