class UserMailer < ApplicationMailer

  def leave_request_status(user,leave)
    @user = user
    @leave = leave
    mail(to: @user.email, subject: leave.status)
  end

  def leave_request_email(user,leave)
    @user = user
    @leave = leave
    mail(to: "admin@mail.com", subject: 'Employee requested for leave')
  end

  def leave_request_email_edited(user,leave)
    @user = user
    @leave = leave
    mail(to: @user.email, subject: 'Employee requested for leave is edited ')
  end  
end