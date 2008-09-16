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

  def display_author_name(blog)
    
  end

  def timelong(time)
      time.strftime('%y-%m-%d %H:%M') if time
  end
end
