# To change this template, choose Tools | Templates
# and open the template in the editor.

module ControllerExtend

  def render_liquid(path_info={},local_assigns={})
    template = path_info[:template].blank? ? current_theme.index_liquid_template + '.liquid' : "#{current_theme.view_path}/#{path_info[:template]}.liquid"
    layout = liquid_layout(path_info[:layout])
    unless layout.blank?
      content = parse_template(template,local_assigns)
      render :text => parse_template(layout,{'content' => content,'sidebar_content' => generate_sidebar_content})
    else
      render_file(template, true, local_assigns)
    end
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
    sidebar_infos = SidebarUser.user_sidebars(current_blog_user.id).map{|bar|
      Sidebar.find(bar.sidebar_id)}.compact.map{|sidebar|sidebar.get_content(sidebar_options())}
    sidebar_infos.join('   ')
  end
  
  def sidebar_options
    options = {:user_id => current_blog_user.id}
    options[:month] = params[:month] unless params[:month].blank?
    options[:date]  = params[:date]  unless params[:month].blank?
    options
  end
  
  def parse_template(template,options)
    Liquid::Template.file_system = Liquid::LocalFileSystem.new(template)
    Liquid::Template.parse(IO.read(template)).render(options)
  end
  
  # Retrieves the current set theme
  def current_theme(passed_theme=nil)
    theme_name = unless passed_theme .blank?
      passed_theme
    else
      current_blog_user ? current_blog_user.theme_name : ''
    end
    @curent_theme = Theme.find(theme_name)
  end

  def current_theme_name
    theme = current_theme
    theme ? theme.name : ''
  end
  
  def current_blog_user
    @user ||= User.find_by_user_name(request.subdomains.first)
  end   
end
