module UserHelper
  
  def group_name(group)
    case group
    when "user"
      "普通用户"
    when "silver"
      "银卡用户"
    when "gold"
      "金卡用户"
    when "vendor"
      "企业供应商"
    when "customer"
      "企业用户"
    end
  end
  
  def generate_company_nature_radio(selected_value)
    selected_value ||= UserProfile::Company_Nature_Other
    options = []
    options << radio_button_tag('user_profile[company_nature]',
      UserProfile::Company_Nature_Other,selected_value == UserProfile::Company_Nature_Other) + "其他&nbsp;&nbsp;&nbsp;"
    options << radio_button_tag('user_profile[company_nature]',
      UserProfile::Company_Nature_Suppliers,selected_value == UserProfile::Company_Nature_Suppliers) + "供应商&nbsp;&nbsp;&nbsp;"
    options << radio_button_tag('user_profile[company_nature]',
      UserProfile::Company_Nature_User,selected_value == UserProfile::Company_Nature_User) + "用户商&nbsp;&nbsp;&nbsp;"
  end
  
  def generate_vocations_select(select_value)
    options = [['请选择','0']]+Vocation.all_vocations.map{|v| [v.vocation_name,v.id.to_s]}
    return options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end
end
