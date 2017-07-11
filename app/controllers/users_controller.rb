class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :find_user, except: [:new, :index, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".welcome"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts = @user.microposts.desc.paginate page: params[:page],
      per_page: Settings.paginate.page
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".success", user: @user.name
    redirect_to users_url
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".warn"
    redirect_to login_url
  end

  def correct_user
    return if @user.current_user? current_user
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?
    redirect_to root_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".usernotfound"
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user)
      .permit :name, :email, :password, :password_confirmation
  end
end
