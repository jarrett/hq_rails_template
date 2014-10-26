require 'test_helper'

class AccountTest < ActionDispatch::IntegrationTest
  test 'join successfully' do
    visit '/'
    assert_logged_out
    click_link 'Join'
    if User.has_login_field?
      fill_in 'user_login', with: 'johnq'
    end
    fill_in 'user_email', with: 'johnqpublic@example.com'
    fill_in 'user_password', with: 'a7pRB9>A'
    fill_in 'user_password_confirmation', with: 'a7pRB9>A'
    select '(GMT-06:00) Central Time (US & Canada)', from: 'user_time_zone'
    click_button 'Join'
    
    assert_text 'Thanks for joining.'
    assert_logged_out
    u = User.last
    assert_equal 'johnqpublic@example.com', u.email
    assert_nil u.read_attribute(:new_email)
    assert_equal 'Central Time (US & Canada)', u.time_zone
    
    open_email 'johnqpublic@example.com'
    current_email.click_link 'Activate your account'
    assert_text 'Your account has been activated.'
    assert_logged_in
    click_link 'Account'
    assert_equal '/account', current_path
    u.reload
    assert u.activated
  end
  
  test 'change and confirm address' do  
    login User.make!(login: 'johnq', email: 'old@example.com')
    assert_equal 'old@example.com', @me.email
    assert_equal 'old@example.com', @me.new_email
    
    # Submit address change form.
    visit '/account'
    fill_in 'user_new_email', with: 'new@example.com'
    click_button 'Save'
    assert_text(
      'An email has been sent to your new address. Please follow the instructions in ' +
      'that email to confirm your new address. Until then, we will continue to use ' + 
      'your old address.'
    )
    @me.reload
    assert_equal 'old@example.com', @me.email
    assert_equal 'new@example.com', @me.new_email
    
    # Confirm new address.
    open_email 'new@example.com'
    current_email.click_link 'Activate your account'
    assert_text 'Your email address has been confirmed.'
  end
  
  test 'change password' do
    login User.make!(password: 'j4Fu%nA!', password_confirmation: 'j4Fu%nA!')
    click_link 'Account'
    fill_in 'user_password', with: '&nv1W4zA0c[LqR'
    fill_in 'user_password_confirmation', with: '&nv1W4zA0c[LqR'
    click_button 'Save'
    assert_text 'Your password has been changed'
    assert_equal '/login', current_path
    assert_no_email
    login @me, password: '&nv1W4zA0c[LqR'
  end
  
  test 'change time zone' do
    login User.make! time_zone: 'Central Time (US & Canada)'
    click_link 'Account'
    select 'Eastern Time (US & Canada)', from: 'user_time_zone'
    click_button 'Save'
    assert_text 'Account settings saved'
    @me.reload
    assert_equal 'Eastern Time (US & Canada)', @me.time_zone
  end
end