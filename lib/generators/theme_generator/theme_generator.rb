class ThemeGenerator < Rails::Generator::NamedBase
     
   def manifest
      record do |m|

         if file_name != '_system_'
            # Theme folder(s)
            m.directory File.join( "themes", file_name )
            m.template 'about.markdown', File.join( 'themes', file_name, 'about.markdown' )
            m.template 'preview.png', File.join( 'themes', file_name, 'preview.png' )
         
            m.directory File.join( "themes", file_name, "stylesheets" )
            m.template "theme.css", File.join( "themes", file_name, "stylesheets", "#{file_name}.css" )

            m.directory File.join( "themes", file_name, "layouts" )
            m.template 'layout.rhtml', File.join( 'themes', file_name, 'layouts', 'default.rhtml' )
            m.template 'layout.liquid', File.join( 'themes', file_name, 'layouts', 'default.liquid' )

            m.directory File.join( "themes", file_name, "views" )
            m.directory File.join( "themes", file_name, "images" )
            m.directory File.join( "themes", file_name, "javascript" )
         end
         
         theme_support_dir = File.join( "vendor", "plugins", "theme_support" )

         if !File.directory?( theme_support_dir ) or file_name == '_system_'
         
           # Readme file
           m.template 'README', "README_THEMES"

           # The ThemeEngine plugins
           m.directory File.join( "vendor", "plugins", "theme_support" )
           m.template 'README', File.join( "vendor", "plugins", "theme_support", 'README' )
           m.template 'LICENSE', File.join( "vendor", "plugins", "theme_support", 'LICENSE' )
           m.template 'init.rb', File.join( 'vendor', 'plugins', 'theme_support', 'init.rb' )
           
           m.directory File.join( "vendor", "plugins", "theme_support", "lib" )
           m.template 'theme.rb', File.join( 'vendor', 'plugins', 'theme_support', 'lib', 'theme.rb' )
           m.template 'theme_controller.rb', File.join( 'vendor', 'plugins', 'theme_support', 'lib', 'theme_controller.rb' )
           m.template 'theme_helper.rb', File.join( 'vendor', 'plugins', 'theme_support', 'lib', 'theme_helper.rb' )
           
           m.directory File.join( "vendor", "plugins", "theme_support", "lib", "patches" )
           m.template 'actionview_ex.rb', File.join( 'vendor', 'plugins', 'theme_support', 'lib', "patches", 'actionview_ex.rb' )
           m.template 'routeset_ex.rb', File.join( 'vendor', 'plugins', 'theme_support', 'lib', "patches", 'routeset_ex.rb' )
           m.template 'actioncontroller_ex.rb', File.join( 'vendor', 'plugins', 'theme_support', 'lib', "patches", 'actioncontroller_ex.rb' )

           m.directory File.join( "vendor", "plugins", "theme_support", "lib", "helpers" )
           m.template 'liquid_theme_tags.rb', File.join( 'vendor', 'plugins', 'theme_support', 'lib', 'helpers', 'liquid_theme_tags.rb' )
           m.template 'rhtml_theme_tags.rb', File.join( 'vendor', 'plugins', 'theme_support', 'lib', 'helpers', 'rhtml_theme_tags.rb' )

           m.directory File.join( "vendor", "plugins", "theme_support", "tasks" )
           m.template 'themes.rake', File.join( 'vendor', 'plugins', 'theme_support', 'tasks', 'themes.rake' )
           
         end
      end
   end
end