class SessionsController < ApplicationController
  before_action :find_user, only: :create
  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = t ".not-actived"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t ".error-login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
  def find_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user
    flash.now[:danger] = t ".error-login"
    render :new
  end
end
