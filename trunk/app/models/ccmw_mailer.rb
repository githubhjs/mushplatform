class CcmwMailer < ActionMailer::Base
  
  def send(to_mail,password)
    subject      '您在ccmw注册的密码，敬请小心保管'
    recipients   to_mail
    from         'ccmwadmin@gmail.com'
    sent_on      Time.now
    body         :password => password
  end

end
