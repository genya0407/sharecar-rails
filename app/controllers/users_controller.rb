class UsersController < ApplicationController
  skip_before_action :require_login, only: [:activate, :confirm]
  before_action :should_be_admin, except: [:show, :index, :activate, :confirm]

  def index
    @users = User.all
  end

  def new
    @users = User.all
    @user = User.new
  end

  def create
    @user = User.new(user_invite_params)
    if @user.save
      redirect_to action: :new, notice: "Sent invitation to #{@user.email}."
    else
      @users = User.all
      render action: :new
    end
  end

  def show
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @token = params[:id]
    else
      not_authenticated
    end
  end

  def confirm
    @token = params[:id]
    if @user = User.load_from_activation_token(@token)
      if @user.update_attributes(user_confirm_params)
        @user.activate!
        auto_login @user
        redirect_to :root
      else
        render :activate
      end
    else
      not_authenticated
    end
  end

  private
    def user_invite_params
      params.require(:user).permit(:email)
    end

    def user_confirm_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
