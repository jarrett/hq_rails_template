class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_login_or_email if User.has_login_field?
  
  validate :must_be_activated
	
	def bad_credentials?
	  errors.include?(:login) or errors.include?(:email) or errors.include?(:password)
	end
	
	private
	
	def must_be_activated
	  if attempted_record and !attempted_record.activated
      errors.add(:activation, 'You have not yet activated your account.')
    end
	end
end