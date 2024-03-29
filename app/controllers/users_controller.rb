class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[activate confirm resend_invitation]
  before_action :should_be_admin, except: %i[show index activate confirm]
  before_action :set_users, only: %i[index new create resend_invitation]

  def index; end

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
    return render action: :new, status: :unprocessable_entity unless @user.present?

    if @user.activation_token.nil?
      @user.activation_token = Sorcery::Model::TemporaryToken.generate_random_token
      @user.save!
    end
    @user.send(:send_activation_needed_email!)
    redirect_to action: :new
  end

  def show; end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @token = params[:id]
    else
      not_authenticated
    end
  end

  def deactivate
    User.find(params[:id]).disable!

    redirect_to action: :new
  end

  def confirm
    @token = params[:id]
    @user = User.load_from_activation_token(@token)
    return not_authenticated unless @user

    if @user.update(user_confirm_params)
      @user.activate!
      auto_login @user
      redirect_to :root
    else
      render :activate, status: :unprocessable_entity
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
    @users = User.all.order(:activation_state)
  end
end
