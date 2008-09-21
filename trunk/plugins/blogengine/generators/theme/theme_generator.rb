class ThemeGenerator < Rails::Generator::NamedBase
     
  def manifest
    record do |m|
      # Theme folder(s)
      theme_path = File.join("#{RAILS_ROOT}","themes",file_name)
      m.directory theme_path
      # theme content folders
      m.directory File.join( theme_path, "images" )
      m.directory File.join( theme_path, "javascripts" )
      m.directory File.join( theme_path, "layouts" )
      m.directory File.join( theme_path, "views" )
      m.directory File.join( theme_path, "stylesheets" )
      # Default files...
      # about
      m.template 'about.markdown', File.join( theme_path, 'about.markdown')
      # image
      m.file 'preview.png', File.join( theme_path, 'images', 'preview.png' )
      # stylesheet
      m.template "theme.css", File.join( theme_path, "stylesheets", "#{file_name}.css" )
      # layouts
      m.template 'layout.rhtml', File.join( theme_path, 'layouts', 'default.rhtml' )
      m.template 'layout.liquid', File.join( theme_path, 'layouts', 'default.liquid' )
      # view readme
      m.template 'views_readme', File.join( theme_path, 'views', 'views_readme.txt' )
    end
  end
end