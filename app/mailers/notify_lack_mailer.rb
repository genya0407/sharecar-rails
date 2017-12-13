class NotifyLackMailer < ApplicationMailer
  def lack_exist_email(cars)
    @cars = cars
    subject = if cars.empty?
                '乗車記録に欠落はありません'
              else
                '乗車記録に欠落があります'
              end
    mail(:to => Rails.application.secrets.mailing_list_address,
         :subject => subject)
  end
end
