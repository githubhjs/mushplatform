module BlogHelper
    
  def entry_permalink(entry)
    link_to entry['title'], "/blogs/#{entry['id']}", :title => entry['title']
  end

  def display_sidebar(user)
    sidebar_infos = SidebarUsers.user_sidebars.map{|bar|
      Sidebar.find(bar.sidebar_id)}.compact.map{|sidebar|sidebar.get_content(sidebar_options())}
    sidebar_infos.join('   ')
  end

#  def timelong(time)
#      time ? time.strftime('%m/%d/%y %H:%M:%S') : "No Time"      
#  end   
#  
#  def gravatar_tag(email, options={})
#    options.update(:gravatar_id => Digest::MD5.hexdigest(email.strip))
#    options[:default] = CGI::escape(options[:default]) if options.include?(:default)
#    options[:size] ||= 60
#
#    image_tag("http://www.gravatar.com/avatar.php?" <<
#      options.map { |key,value| "#{key}=#{value}" }.sort.join("&"), :class => "gravatar")
#  end
  
end
