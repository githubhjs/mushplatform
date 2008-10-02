module CalendarSidebarHelper

  extend CalendarHelper
  
  def self.get_context(params = {})
    date = params[:month] ? Date.parse(params[:month]) :( params[:date] ? Date.parse(params[:date]) : Date.today)   
    next_date = next_month_and_year(date)
    previous_date =  previous_month_and_year(date)
    calendar({:year => date.year, :month =>date.month,:show_today => true,
        :previous_month_text => "<a href='/?month=#{previous_date}'>上个月</a>",:next_month_text => "<a href='/?month=#{next_date}'>下个月</a>"}) do |d|
      cell_text = "#{d.mday}<br />"
      cell_attrs = {:class => 'day'}
      count = Blog.blog_count_by_day(d,params[:user_id])
      if count > 0
        cell_text = "<a href='/?date=#{d}' style='background-color: #003355;front-color:white;' title='查看今天日志'>#{d.mday}</a>"
#        cell_attrs[:class] = 'specialDay'
        [cell_text, cell_attrs]
      end
    end
  end
  
  def self.next_month_and_year(day)
    day.month < 12 ?  "#{day.year()}-#{day.month() +1}-1" : "#{day.year() + 1}-1-1"
  end

  def self.previous_month_and_year(day)
    day.month == 1 ? "#{day.year() - 1}-12-1" : "#{day.year()}-#{day.month() -1}-1"
  end
  
  def self.get_edit_context(options = {})
    {}
  end
  
end