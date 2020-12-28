class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def create
    @user = login(params[:email], params[:password], true)
    if @user
      redirect_back_or_to :root
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new', status: :forbidden
    end
  end

  def destroy
    logout
    redirect_to :login
  end
end
