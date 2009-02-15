module MySpaceHelper

  def display_blog_admin_sex
    profile = current_blog_user.user_profile
    if profile
      case profile.sex
      when Const::Sex_Unknown
        '保密'
      when Const::Sex_Woman
        '女'
      when Const::Sex_Man
        '男'
      end
    end
  end
  
end
