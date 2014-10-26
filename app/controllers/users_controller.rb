class UsersController < ApplicationController
  skip_before_filter :require_user, only: [:new, :create, :confirm_email]
  before_filter :require_no_user, only: [:new, :create]
  
  def confirm_email
    if user = User.find_using_email_token(params[:token], 5.days)
      was_unactivated = !user.activated
      user.confirm_email!
      UserSession.create(user)
      if was_unactivated
        redirect_to root_url, notice: 'Your account has been activated.'
      else
        redirect_to root_url, notice: 'Your email address has been confirmed.'
      end
    else
      render action: :bad_confirmation_email
    end
  end
    
  def create
    @user = User.new new_user_params
    if @user.save
			@user.maybe_deliver_email_confirmation! self
			redirect_to root_url, notice: "Thanks for joining. Please check your email for instructions on activating your account."
		else
			render action: :new
		end
  end
  
  def edit
  end
  
  def new
    @user = User.new
  end
  
  def update
    @user = current_user
    if @user.update_attributes existing_user_params
      if @user.maybe_deliver_email_confirmation! self
        notice = 
          'An email has been sent to your new address. Please follow the instructions in ' +
          'that email to confirm your new address. Until then, we will continue to use ' + 
          'your old address.'
      else
        notice = 'Account settings saved.'
      end
      if params[:user][:password].present?
        notice << ' Your password has been changed. Please log back in with your new password.'
        redirect_to login_url, notice: notice
      else
        redirect_to account_url, notice: notice
      end
    else
      render action: :edit
    end
  end
  
  private
  
  def existing_user_params
    params.require(:user).permit([:new_email] + common_user_params)
  end
        
  def new_user_params
    permitted = [:email] + common_user_params
    permitted << [:login] if User.has_login_field?
    params.require(:user).permit(permitted)
  end
  
  def common_user_params
    [:password, :password_confirmation, :time_zone]
  end
end