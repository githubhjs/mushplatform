module Admin::RolesHelper
  
  def display_role_status(role)
    role.status == Role::Status_Valid ? "Valid" : 'Invalid'
  end
  
  def generate_role_status_opetions(select_value)
    options = [['Valid',Role::Status_Valid.to_s],['Invalid',Role::Status_Invalid.to_s]]
    return options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end
end
