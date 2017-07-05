class NotifyLackMailer < ApplicationMailer
  def lack_exist_email(user, cars)
    @cars = cars
    subject = if cars.empty?
                '乗車記録に欠落はありません'
              else
                '乗車記録に欠落があります'
              end
    mail(:to => user.email,
         :subject => subject)
  end
end
