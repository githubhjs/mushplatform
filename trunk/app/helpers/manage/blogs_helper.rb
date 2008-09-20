module Manage::BlogsHelper

  def generate_categories_options(select_value)
    options = [['默认分类','0']] + Category.find(:all).map{|category|[category.name,"#{category.id}"]}
    options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end

  def generate_categories_options_for_list(select_value)
    options = [['全部日志分类','0']] + Category.find(:all).map{|category|[category.name,"#{category.id}"]}
    options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end
  
  def display_category_name(blog)
    blog.category ? blog.category.name :  "无分类"
  end

  def display_publish_notice
    info = if  !flash[:success_notice].blank?
      "<img src='/images/icon_success_lrg.gif'>" + flash[:success_notice]
    elsif !flash[:error_notice].blank?
      <<notice
          <img src='/images/icon_error_lrg.gif'>
          <font color='red'>
            #{flash[:error_notice] }
          </font>
notice
    else
      ""
    end
    info
  end


  def display_author_name(blog)
    
  end

end
