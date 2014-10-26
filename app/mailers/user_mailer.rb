class UserMailer < ActionMailer::Base
  default from: 'No reply <noreply@example.com>'
  
  def email_confirmation(user, controller)
    @url = controller.confirm_email_url user.email_token
    # #new_email defaults to #email if new_email column is blank. So this works for both
    # signup and changing address.
    mail to: user.new_email, subject: 'Confirm your email address'
  end
end