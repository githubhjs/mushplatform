module BlogHelper
  
  def entry_permalink(entry)
    link_to entry['title'], "/entry/#{entry['id']}", :title => entry['title']
  end
  
end
