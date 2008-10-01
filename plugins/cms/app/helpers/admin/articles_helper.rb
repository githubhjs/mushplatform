module Admin::ArticlesHelper
  def status_options
    [['Audited', 1], ['Unaudited', 0]]
  end
  
  def top_options
    [['Untop', 0], ['Top', 1]]
  end
  
  def sticky_options
    [['Unsticky', 0], ['Sticky', 1]]
  end  
end
