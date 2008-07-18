# Authorize
#
# Acknowledgements: I give all credit to Ezra and Technoweenie for their two plugins which
# inspired the interface design and a lot of the code for this one.
#
# Authorize is a streamlined, intuitive authorisation system. It derives heavily from
# acl_system2 and has made clear some problems which plagued the author when first using it. Some
# fixes to acl_system2's design:
#
#       * a normal Rails syntax:
#             grant_to 'admin',:only => :index
#             grant_to '(moderator || admin)', :only => :new
#       * error handling for helper methods (permit? bombs out with current_user == nil)
#       * one-line parser, easy to replace or alter
#       * proper before_filter usage, meaning access rules are parsed only when needed
#       * no overrideable default (which I found counter-intuitive in the end)
# 
# Also, it has two methods, access_control and permit?, for those moving from acl_system2.
#
# But, let me stress, everyone likes a slightly different system, so this one may not be
# your style. I find it synchronises very well with the interface of Acts as Authenticated (even
# though I have modified it so much that it's now called Authenticated Cookie).
#
require 'yaml'
module Authorize
  
  def self.included(base)
    base.extend(ClassMethods)
    if base.respond_to?(:helper_method)
      base.send :helper_method, :is_user_in_role?
    end
  end
  
  module ClassMethods
    # This is the core of the filtering system and it couldn't be simpler:
    #     access_rule '(admin || moderator)', :only => [:edit, :update]
    def grant_to(rule,filter_options = {})
      before_filter(filter_options||{})  do |controller| 
        controller.send :permission_required,rule 
      end
    end
        
  end
  
  protected
  
  # As in AAA you have login_required, here you have permission_required. Pass it a
  # rule and it will use Authorize#has_permission? to evaluate against the
  # current user. Use Authorize#has_permission? if you are not guarding an
  # action or whole controller. An empty or nil rule will always return true.
  #     permission_required('admin')
  def permission_required(rule = nil)
    return(false) if respond_to?(:logged_in?) && !logged_in?
    if has_permission?(rule)
      send(:permission_granted) if respond_to?(:permission_granted)
      true
    else
      send(:permission_denied) if respond_to?(:permission_denied)
      false
    end
  end
    
  def is_user_in_role?(group_name)
    return false if group_name.blank?
    return has_permission?(group_name.to_s)
  end
  
  # For use in both controllers and views.
  #     has_permission?('role')
  #     has_permission?('admin', other_user)
  def has_permission?(rule, user = nil)
    user ||= (send(:current_user)  if respond_to?(:current_user))
    access_controller.process(rule, user)
  end

  def access_controller
    @access_controller ||= AccessControlHandler.new
  end

  # A dramatically simpler version than that found in acl_system2
  # It is SLOWER because it uses instance_eval to analyse the conditional, but it's DRY.
  class AccessControlHandler

    def process(string, user)
      return(check('', user)) if string.blank?
      if string =~ /^([^()\|&!]+)$/ then
        return check($1, user) # it is simple enough to just pump through
      else 
        return instance_eval("!! (#{parse(string)})") # give it the going-over
      end
    end
   
    #"admin||editor => admin|editor"   
    def parse(roles)
      roles.gsub(/(\|+|\&+)/) { $1[0,1]*2 }.gsub(/([^()|&! ]+)/) { "check('#{$1}', user)" }
    end    
    
    # The heart of the system, all credit to Ezra for the original algorithm
    # Defaults to false if there is no user or that user does not have a roles association
    # Defaults to true if the role is blank
    def check(role, user)
      return(false) if user.blank? 
      return(true) if role.blank?
      #Roles.user_roles(user).include? role.downcase
      return Roles.check_role(role,user)
    end
   
  end
  
  #Roles roles
  module Roles   
    Auth_Group_Properties,Auth_Value = {},{}
    YAML::load(File.open(File.dirname(__FILE__)+'/roles.yml')).each do |role,auth_value|
      auth_group ,auth_key =  role.split('_',2)
      next if auth_group.blank? || auth_key.blank? || auth_value.to_i == 0
      Auth_Group_Properties[auth_key] = "#{auth_group}_auth"
      Auth_Value[auth_key] = auth_value.to_i
    end
    
    def self.check_role(role,user)
      property = Auth_Group_Properties[role.to_s]
      auth_value = Auth_Value[role.to_s]
      return property && auth_value && user.respond_to?(property) && (user.send(property) & auth_value == auth_value)
    end
    
    def self.auth_user(user,roles)
      if roles.is_a?(String)
        set_auth_to_user(user,roles)
      elsif roles.is_a?(Array)
        roles.each {|role|set_auth_to_user(user,role)}
      end
    end
    
    def self.unauth_user(user,roles)
      if roles.is_a?(String)
        remove_user_auth(user,roles)
      elsif roles.is_a?(Array)
        roles.each {|role|remove_user_auth(user,role)}
      end 
    end
       
    def self.all_authorizes
      return Auth_Group_Properties.keys
    end
    
    def self.user_authorizes(user)
      user_auth = []
      Auth_Value.each_key do |auth_key|
        user_auth << auth_key if check_role(auth_key,user)
      end
      user_auth
    end
    
    private
    
    def self.remove_user_auth(user,role)
      property = Auth_Group_Properties[role.to_s]
      auth_value = Auth_Value[role.to_s]
      return false if property.nil? || auth_value.nil? || !user.respond_to?(property)
      user.send("#{property}=",(user.send(property) | auth_value) - auth_value)
    end
    
    def self.set_auth_to_user(user,role)
      property = Auth_Group_Properties[role.to_s]
      auth_value = Auth_Value[role.to_s]
      if !property.nil? && !auth_value.nil? &&  user.respond_to?(property)
        user.send("#{property}=",user.send(property) | auth_value)
      end
    end
    
  end  
end
