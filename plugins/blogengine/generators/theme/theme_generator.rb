class ThemeGenerator < Rails::Generator::NamedBase
     
  def manifest
    record do |m|
      # Theme folder(s)
      theme_path = File.join("themes",file_name)
      m.directory theme_path
      # theme content folders
      m.directory File.join( theme_path, "images" )
      m.directory File.join( theme_path, "javascripts" )
      m.directory File.join( theme_path, "stylesheets" )
      m.directory File.join( theme_path, "templates" )
      # Default files...
      # about
      m.template 'about.yml', File.join( theme_path, 'about.yml')
      # image
      m.file 'preview.png', File.join( theme_path, '', 'preview.png' )
      # stylesheet
      m.template "theme.css", File.join( theme_path, "stylesheets", "#{file_name}.css" )
      # layouts
      m.template 'layout.liquid', File.join( theme_path, 'templates', 'layout.liquid' )
      # entries
      m.template 'entries.liquid', File.join( theme_path, 'templates', 'entries.liquid' )
      m.template 'entry.liquid', File.join( theme_path, 'templates', 'entry.liquid' )
    end
  end
end