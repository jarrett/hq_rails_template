class UserSessionsController < ApplicationController
	skip_before_filter :require_user, :only => [:new, :create]

	def new
	  if session[:return_to].blank? and !request.env['HTTP_REFERER'].blank?
  		store_location request.env['HTTP_REFERER']
  	end
		@user_session = UserSession.new
	end

	def create
		@user_session = UserSession.new user_session_params
		if @user_session.save
      return_to = session[:return_to]
      session[:return_to] = nil
      redirect_to(return_to || root_url)
		else
			render :action => :new
		end
	end

	def destroy
		current_user_session.destroy
		flash[:notice] = "You've been logged out."
		redirect_to login_url, notice: "You've been logged out."
	end
	
	private
	
	def user_session_params
	  params.require(:user_session).permit(:login, :email, :password, :remember_me)
	end
end
