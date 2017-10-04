class Admin::PaymentsController < ApplicationController
  def new
    @new_payments = User.all.select(&:should_pay?).map do |user|
      Payment.new(
        user: user,
        amount: user.should_pay
      )
    end
    @saved_payments = Payment.all.order('created_at DESC')
  end

  def create
    payment = Payment.new(create_params)
    payment.save!

    redirect_to action: :new
  end

  def destroy
    Payment.find(params[:id]).destroy!

    redirect_to action: :new
  end

  private
  def create_params
    params.require(:payment)
          .permit(:amount, :user_id)
  end
end