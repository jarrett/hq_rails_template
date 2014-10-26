require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'creation' do
    attrs = {email: 'nobody@example.com', password: 'v9a!lpo"Xsd38', password_confirmation: 'v9a!lpo"Xsd38'}
    if User.has_login_field?
      attrs[:login] = 'nobody'
    end
    u = User.create! attrs
    refute u.activated
  end
end