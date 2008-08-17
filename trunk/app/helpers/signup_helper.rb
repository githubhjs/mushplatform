module SignupHelper
  
  def generate_company_nature_radio(selected_value)
    other = (selected_value.to_s == UserProfile::Company_Nature_Other.to_s) ? false : true
    options = []
    options << radio_button_tag('profile[company_nature]',
      UserProfile::Company_Nature_Other.to_s,other) + "其他&nbsp;&nbsp;&nbsp;"
    options << radio_button_tag('profile[company_nature]',
      UserProfile::Company_Nature_Suppliers.to_s,selected_value.to_s == UserProfile::Company_Nature_Suppliers.to_s) + "供应商&nbsp;&nbsp;&nbsp;"
    options << radio_button_tag('profile[company_nature]',
      UserProfile::Company_Nature_User.to_s,selected_value.to_s == UserProfile::Company_Nature_User.to_s) + "用户商&nbsp;&nbsp;&nbsp;"
  end
  
  def generate_vocations_select(select_value)
    options = [['请选择','0']]+Vocation.all_vocations.map{|v| [v.vocation_name,v.id.to_s]}
    return options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end
end
