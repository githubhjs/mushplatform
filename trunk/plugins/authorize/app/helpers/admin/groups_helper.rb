module Admin::GroupsHelper
  
  def display_group_status(group)
    group.status == Group::Status_Valid ? "Valid" : 'Invalid'
  end
  
  def generate_group_status_opetions(select_value)
    options = [['Valid',Group::Status_Valid.to_s],['Invalid',Group::Status_Invalid.to_s]]
    return options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end
    
  def generate_roles_checkbox(group)
    roles = Role.all_roles
    return "" if roles.blank? || roles.size <= 0
    self_role_ids = group.new_record? ? [] : group.roles.map(&:id)
    check_boxes = []
    self_role_ids.map! { |r_id| r_id.to_i }
    inherit_roles =  group.inherit_group.nil? ? [] : group.inherint_roles(group.inherit_group)
    inherit_role_ids = inherit_roles.map(&:id)
    roles.delete_if{|r| inherit_role_ids.include?(r.id)}
    check_box_options = []
    roles.each do |role|
      checked = self_role_ids && self_role_ids.include?(role.id)
      check_box_options << ['group_auth[]',role.id,checked,role.role_name]
    end
    inherit_roles.each do |i_role|
      check_box_options << ['auth[]',i_role.id,true,i_role.role_name]
    end
    check_box_options.sort! { |f,s| f[1] <=> s[1] }
    check_box_options.each do |opt|
      check_boxes <<  (check_box_tag(opt[0],opt[1],opt[2]) + opt[3])
    end
    return check_boxes.join(' ')
  end
  
  def generate_inherit_group_options(group)
    options = [['No','0']]
    options += group.should_inherit_groups.map{|g|[g.group_name,g.id.to_s]}
    return options_for_select(options, group.inherit_group_id ? group.inherit_group_id.to_s : nil )
  end
end
