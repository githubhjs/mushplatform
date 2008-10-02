module CalendarSidebarHelper
  extend CalendarHelper
  def self.get_context(option = {})
    today = Date.today
    calendar({:year => today.year, :month => today.month,:show_today => true,:previous_month_text => "上个月",
        :next_month_text => "下个月"}) do |d|
      cell_text = "#{d.mday}<br />"
      cell_attrs = {:class => 'day'}
      if Blog.day_blogs(d).count(:all) >= 1
        cell_text << "<a href='/blogs?day=#{d}'>#{d.mday}</a><br />" << "<br />"
        cell_attrs[:class] = 'specialDay'
        [cell_text, cell_attrs]
      end
    end
  end   
  def self.get_edit_context(options = {})
    {}
  end
  
end