module CalendarSidebarHelper
  extend CalendarHelper
  def self.get_context(option = {})
    today = Date.today
    calendar({:year => today.year, :month => today.month}) do |d| 
      cell_text = "#{d.mday}<br />"
      cell_attrs = {:class => 'day'}
      [].each do |e|
        if e.startdate == d
          cell_text << e.name << "<br />"
          cell_attrs[:class] = 'specialDay'
        end
      end
      [cell_text, cell_attrs]
    end
  end
    
  def self.get_edit_context(options = {})
    {}
  end
  
end