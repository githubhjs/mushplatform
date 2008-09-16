module Manage::BlogsHelper

  def generate_categories_options(select_value)
    options = [['默认分类','0']] + Category.find(:all).map{|category|[category.name,"#{category.id}"]}
    options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end
  
end
