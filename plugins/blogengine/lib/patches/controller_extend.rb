module ControllerExtend

  protected

  def render_liquid(path_info={},local_assigns={})
    template = path_info[:template].blank? ? current_theme.index_liquid_template + '.liquid' : "#{current_theme.view_path}/#{path_info[:template]}.liquid"
    layout = liquid_layout(path_info[:layout])
    unless layout.blank?
      content = parse_template(template,local_assigns)
      home = "http://#{request.host_with_port}"
      render :text => parse_template(layout,{'content' => content,'sidebar_content' => generate_sidebar_content,
          'blog_name' => current_blog_user.blog_config.blog_name,'announcement' => current_blog_user.blog_config.announcement, 'home' => home,'if_login' => current_user})
    else
      render :text =>  parse_template(template,local_assigns)
    end
  end
  
  def theme_layout
    current_theme.sns_layout
  end

  def parse_liquid(template,options)
    parse_template("#{current_theme.view_path}/#{template}.liquid",options)
  end
  
  def liquid_layout(pass_layout)
    layout = case pass_layout
    when Symbol     then  "#{send(pass_layout)}.liquid"
    when Proc       then  "#{pass_layout.call(self)}.liquid"
    when String     then  "#{pass_layout}.liquid"
    when TrueClass  then  "#{current_theme.liquid_layout}.liquid"
    when FalseClass then nil
    else
      raise 'invalud args'
    end
    layout
  end
  
  def generate_sidebar_content
    sidebar_contents = SidebarUser.user_sidebars(current_blog_user.id).map{|bar|
      #Sidebar.find(bar.sidebar_id)}.compact.map{|sidebar|sidebar.get_content(sidebar_options().merge({:id =>sidebar.id}))
      sidebar = Sidebar.find( bar.sidebar_id )
      sidebar.get_content(sidebar_options().merge({:id => bar.id}))
    }
    sidebar_contents.join('   ')
  end
  
  def sidebar_options
    options = {:user_id => current_blog_user.id}
    options[:year]  = params[:year]   unless params[:year].blank?
    options[:month] = params[:month]  unless params[:month].blank?
    options[:date]  = params[:date]   unless params[:month].blank?
    options
  end
  
  def parse_template(template,options)
    Liquid::Template.file_system = Liquid::LocalFileSystem.new(current_theme.view_path)
    Liquid::Template.parse(IO.read(template)).render(options)
  end
  
  # Retrieves the current set theme
  def current_theme(passed_theme = nil)
    theme_name = unless passed_theme .blank?
      passed_theme
    else
      current_blog_user ? current_blog_user.blog_config.theme_name : ''
    end
    Theme.find(theme_name)
  end

  def current_theme_name
    theme = current_theme
    theme ? theme.name : ''
  end
  
  def current_blog_user
    if session[:pre_subdomains].blank? || session[:pre_subdomains] != request.subdomains.first
      session[:current_blog_user]  =  User.find_by_user_name(request.subdomains.first)
      session[:pre_subdomains]     = request.subdomains.first
    end
    session[:current_blog_user]
  end
  
  def setup_theme
    if current_theme and current_theme.is_sns_theme?
      self.view_paths = ::ActionController::Base.view_paths.dup.unshift(current_theme.sns_theme_view)
    end
  end
  
end
