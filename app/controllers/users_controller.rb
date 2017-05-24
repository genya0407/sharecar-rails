class UsersController < ApplicationController
  skip_before_action :require_login, only: [:activate, :confirm, :resend_invitation]
  before_action :should_be_admin, except: [:show, :index, :activate, :confirm]
  before_action :set_users, only: [:index, :new, :create, :resend_invitation]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_invite_params)
    if @user.save
      flash[:notice] = "Sent invitation to #{@user.email}."
      redirect_to action: :new
    else
      render action: :new
    end
  end

  def resend_invitation
    @user = User.find_by(id: params[:id])

    if @user.present?
      UserMailer.activation_needed_email(@user).deliver
      render action: :new
    else
      render action: :new, status: :unprocessable_entity
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
        render :activate, status: :unprocessable_entity
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
      params.require(:user).permit(:name, :phone_number, :password, :password_confirmation)
    end

    def set_users
      @users = User.all
    end
end
