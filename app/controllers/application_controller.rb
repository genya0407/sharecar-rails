class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login
  force_ssl if: :ssl_configured? 

  private
    def not_authenticated
      redirect_to login_path, alert: "Please login first"
    end

    def should_be_admin
      redirect_to :root, alert: 'Administrator only' unless current_user&.admin?
    end

    def ssl_configured?
      Rails.env.production?
    end
end
