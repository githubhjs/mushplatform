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
      return AuthManager.check_auth(user, role)
    end
   
  end
  
  module AuthManager
        
    class << self
      #check if the special use has auth of role_name
      def check_auth(user,role_name)
        return false if user.blank? || role_name.blank?
        if user.respond_to?(:authorizations)
          return user.authorizations.find{|auth|auth.role_name == role_name.strip}
        else
          user.class.class_eval do 
            define_method(:authorizations) do
              @auth ||= self.groups.map{|g|g.own_and_inherint_roles}.flatten
            end
          end
          return user.authorizations.find{|auth|auth.role_name == role_name.strip}
        end 
      end
                 
      #authorize user
      def auth_user(user,groups)
        role_names = []
        groups.each do |g|
          GroupUser.create(:user_id => user.id,:group_id => g.id)
          role_names << g.roles.map(&:role_name)
        end
        user.auth_values = "#{user.auth_values}#{role_names.join(',')},"
        user.save
      end
        
      #remove auth from user
      def unauth_user(user,groups)
        groups.each do |g|  
          GroupUser.delete_all("user_id=#{user.id} and group_id = #{g.id}")
        end
      end 
      
      #authoirze group
      def auth_group(group,roles)
        if roles.size > 0
          roles.each do |role|
            GroupRole.create(:group_id => group.id,:role_id => role.id)
          end
          group.update_own_roles_cache
        end
      end
      
      #Un authorize group
      def unauth_group(group,roles)
        r_ids = roles.map(&:id)
        GroupRole.delete_all("group_id=#{group.id} and role_id in (#{r_ids.join(',')})") if r_ids.size > 0
        group.update_own_roles_cache
      end
      
    end
  end
  
end
 #reduce user's authorize
#          User.connection.execute("update users set auth_values=REPLACE(auth_values,'#{r.role_name},','')  where 
#                  id in (select user_id from group_users where group_id=#{group.id})")
#add user's atuhroize
#        if role_names.size > 0
#          user_auths = "#{role_names.join(',')},"
#          User.connection.execute("update users set auth_values= CONCAT(auth_values,'#{user_auths}') where 
#                  id in (select user_id from group_users where group_id=#{group.id})")
#        end