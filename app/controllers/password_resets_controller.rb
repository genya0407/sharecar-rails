class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def create
    @user = User.find_by_email(params[:email])
    @user&.deliver_reset_password_instructions!

    flash[:notice] = 'メールが送信されました。'
    redirect_to root_path
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    return not_authenticated if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]
    return render action: 'edit' unless @user.change_password!(params[:user][:password])

    flash[:notice] = 'パスワードが変更されました。'
    redirect_to root_path
  end
end
