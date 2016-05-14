class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :setup
  protected

  def setup
    if user_signed_in?
      session[:user_score] ||= current_user.score % 60 * 100 / 60
 	  @user_score = session[:user_score] || 0
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email) }
  end
end
