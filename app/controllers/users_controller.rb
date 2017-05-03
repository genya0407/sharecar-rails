class UsersController < ApplicationController
  skip_before_action :require_login, only: [:activate]
  before_action :should_be_admin, except: [:show, :index, :activate]

  def index
    @users = User.all
  end

  def show
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to(login_path, :notice => 'User was successfully activated.')
    else
      not_authenticated
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to :users
    else
      render action: :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
