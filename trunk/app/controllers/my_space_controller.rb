class MySpaceController < ApplicationController
  
  include ControllerExtend
  
  Blog_Count_PerPage =   5

  include ThememExt
  
  def index
    entries = Blog.publised_blogs.paginate(:page => params[:page]||1,:per_page => Blog_Count_PerPage,
      :conditions =>generate_conditions)
    render_liquid({:template => 'entries',:layout => true},{'entries' => entries, 'page' => params[:page]||1, 'will_paginate_options' => {'prev_label' => '上一页','next_label' => '下一页'}})
  end

  protected
   def generate_conditions
    conditions = ["user_id=#{current_blog_user.id}"]
    #如果是安月份查询
    unless params[:month].blank?
      m_dates = [31,28,31,30,31,30,31,31,30,31,30,31]
      limit_date  = Date.parse(params[:month])
      max_date = limit_date + m_dates[limit_date.month-1] - 1
      conditions <<  "(updated_at >= '#{limit_date}' and updated_at <= '#{max_date}')"
    end
    #如果是按日期查询
    unless params[:date].blank?
      date = Date.parse(params[:date])
      conditions <<  "(updated_at >= '#{date}' and updated_at <= '#{date.next}')"
    end
    #如果是按照关键字搜索的
    unless params[:keyword].blank?
      conditions << Blog.generate_sql_from_arry(["(title like ? or body like ?  or keywords like ?)","%#{params[:keyword]}%","%#{params[:keyword]}%","%#{params[:keyword]}%"])
    end
    #如果是按照类别查询
    unless params[:category_id].blank?
      conditions << "category_id=#{params[:category_id]}"
    end
    #如果是按照tag管理
    unless params[:tag].blank?
      conditions << ["keywords like ?","%#{params[:tag]}%"]
    end
    conditions.join(' and  ')
  end
  
end