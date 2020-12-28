class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = User.find user.id
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email,
         subject: 'Your password has been reset')
  end

  def activation_needed_email(user)
    @user = user
    @url  = activate_user_url(id: user.activation_token)
    mail(to: user.email,
         subject: 'Activation')
  end
end
