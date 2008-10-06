module Manage::BlogConfigsHelper

  def generate_theme_options(selected_value)
    options = Theme.find_all_theme.map{|theme|[theme.title,theme.name]}
    options_for_select(options, selected_value.blank? ? Theme::Default_Theme_Name : selected_value)
  end

end
