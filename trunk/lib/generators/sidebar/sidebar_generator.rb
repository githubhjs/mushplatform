class SidebarGenerator < Rails::Generator::NamedBase

  def manifest
    
    record do |m|
      theme_path = File.join("sidebars",file_name)
      m.directory "#{theme_path}/helpers"
      m.directory "#{theme_path}/views"
      m.template 'description.yml',       "#{theme_path}/description.yml"
      m.template 'helpers/sidebar_helper.rb', "#{theme_path}/helpers/#{file_name.underscore}_sidebar_helper.rb"
      m.template 'views/content.liquid', "#{theme_path}/views/content.liquid"
      m.template 'views/edit.liquid', "#{theme_path}/views/edit.liquid"
    end

  end

end
