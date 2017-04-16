class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :should_be_admin, except: [:show, :index]

  def index
    @users = User.all
  end

  def show
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
