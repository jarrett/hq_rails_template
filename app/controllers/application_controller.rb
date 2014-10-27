class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user
  
  before_filter :require_user
  
  # These match the alert class names in Bootstrap. (You can still use them even if you
  # don't use Bootstrap, though.)
  add_flash_types :success, :info, :warning, :danger
  
  def current_user_session
		return @current_user_session if defined?(@current_user_session)
		@current_user_session = UserSession.find
	end

	def current_user
		return @current_user if defined?(@current_user)
		@current_user = current_user_session && current_user_session.record
	end
	
	def require_admin
	  unless current_user and current_user.admin
	    store_location
	    redirect_to login_url
			return false
	  end
	end
	
	def require_no_user
	  if current_user
			redirect_to root_url, notice: 'You must be logged out to access that page.'
			return false
	  end
	end
	
	def require_user
		unless current_user
			store_location
			redirect_to login_url, notice: 'You must be logged in to access that page.'
			return false
		end
	end
	
	def store_location(loc = nil)
		session[:return_to] = loc || request.fullpath
	end
end
