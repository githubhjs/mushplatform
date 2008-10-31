module BlogHelper

  def list_blog_entries(args = {})
    order = args.delete(:order) || 'created_at DESC'
    per_page = args.delete(:per_page) || 20
    offset = args.delete(:offset) || 0
    page = args.delete(:page) || 1
    will_args = args
    
    entries = Blog.publised_blogs.paginate :page => page, :order => order, :per_page => per_page, :offset => offset
    { 'entries' => entries, 'will_paginate_options' => will_args }
  end
  
  def entry_permalink(entry)
    "/entry/#{entry['id']}"
  end
  
  def entry_link(entry)
    link_to entry['title'], entry_permalink(entry), :title => entry['title']
  end
  
  def comment_body_extract(comment)
    body = comment['body'].substr(0, 12)
    body = "#{body} ..." if body.size > 24
    body
  end
  
  def display_sidebar(user)
    sidebar_infos = SidebarUsers.user_sidebars.map{|bar|
      Sidebar.find(bar.sidebar_id)}.compact.map{|sidebar|sidebar.get_content(sidebar_options())}
    sidebar_infos.join('   ')
  end

  def display_blog_tags(blog)
    blog = Blog.find(blog['id'])
    blog.tag_list.map{|tag| "<a href='/tag/#{tag}/articles' title='#{tag}'>#{tag}</a>"}.join(" ")
  end
  def parse_year_of_date(date_str)
    date = parse_date_from_str(date_str)
    date ? date.year : ''
  end

  def parse_month_of_date(date_str)
    date = parse_date_from_str(date_str)
    date ? date.month : ''
  end

  def parse_date_from_str(date_str)
    dates = date_str.split('-')
    dates[2] = '01'
    Date.parse(dates.join('-'))
  end

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
