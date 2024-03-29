module CalendarSidebarHelper

  extend CalendarHelper
  
  def self.get_context(params = {})
    date = unless params[:year].blank? or params[:month].blank?
      day = params[:date].blank? ? 1 : params[:date]
      Date.parse("#{params[:year]}-#{params[:month]}-#{day}")
    else
      Date.today
    end
    #    date = params[:month] ? Date.parse(params[:month]) :( params[:date] ? Date.parse(params[:date]) : Date.today)
    next_month_path = next_month_and_year(date)
    previous_month_path =  previous_month_and_year(date)
    calendar({:year => date.year, :month =>date.month,:show_today => true,
        :previous_month_text => "<a href='#{previous_month_path}'>上个月</a>",:next_month_text => "<a href='#{next_month_path}'>下个月</a>"}) do |d|
      cell_text = "#{d.mday}<br />"
      cell_attrs = {:class => 'day'}
      count = Blog.blog_count_by_day(d,params[:user_id])
      if count > 0
        cell_text = "<a href='/articles/#{d.year}/#{d.month}/#{d.mday}' style='background-color: #003355;front-color:white;' title='查看今天日志'>#{d.mday}</a>"
        #        cell_attrs[:class] = 'specialDay'
        [cell_text, cell_attrs]
      end
    end
  end
  
  def self.next_month_and_year(day)
    day.month < 12 ?  "/articles/#{day.year()}/#{day.month() +1}" : "/#{day.year() + 1}/1"
  end

  def self.previous_month_and_year(day)
    day.month == 1 ? "/articles/#{day.year() - 1}/12" : "/articles/#{day.year()}/#{day.month() -1}"
  end
  
  def self.get_edit_context(options = {})
    {}
  end
  
end