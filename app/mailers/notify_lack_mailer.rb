class NotifyLackMailer < ApplicationMailer
  def lack_exist_email(user, cars)
    @cars = cars
    mail(:to => user.email,
         :subject => "乗車記録に欠落があります")
  end
end
