class ThemeGenerator < Rails::Generator::NamedBase
     
  def manifest
    record do |m|
      # Theme folder(s)
      m.directory File.join( "plugins/blogengine/themes", file_name )
      # theme content folders
      m.directory File.join( "plugins/blogengine/themes", file_name, "images" )
      m.directory File.join( "plugins/blogengine/themes", file_name, "javascripts" )
      m.directory File.join( "plugins/blogengine/themes", file_name, "layouts" )
      m.directory File.join( "plugins/blogengine/themes", file_name, "views" )
      m.directory File.join( "plugins/blogengine/themes", file_name, "stylesheets" )
      # Default files...
      # about
      m.template 'about.markdown', File.join( "plugins/blogengine/themes", file_name, 'about.markdown' )
      # image
      m.file 'preview.png', File.join( "plugins/blogengine/themes", file_name, 'images', 'preview.png' )
      # stylesheet
      m.template "theme.css", File.join( "plugins/blogengine/themes", file_name, "stylesheets", "#{file_name}.css" )
      # layouts
      m.template 'layout.rhtml', File.join( "plugins/blogengine/themes", file_name, 'layouts', 'default.rhtml' )
      m.template 'layout.liquid', File.join( "plugins/blogengine/themes", file_name, 'layouts', 'default.liquid' )
      # view readme
      m.template 'views_readme', File.join( "plugins/blogengine/themes", file_name, 'views', 'views_readme.txt' )
    end
  end
end