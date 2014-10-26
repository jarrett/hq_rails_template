require 'test_helper'

class LogInTest < ActionDispatch::IntegrationTest
  def fill_login_field(user)
    if User.has_login_field?
      fill_in 'user_session_login', with: user.login
    else
      fill_in 'user_session_email', with: user.email
    end
  end
  
  test 'log in successfully' do
    u = User.make! email: 'johnqpublic@example.com', password: 'e7(2DZME', password_confirmation: 'e7(2DZME'
    visit '/'
    assert_logged_out
    click_link 'Log in'
    within 'form.new_user_session' do
      fill_login_field u
      fill_in 'user_session_password', with: 'e7(2DZME'
      click_button 'Log in'
    end
    assert_logged_in
  end
  
  if User.has_login_field?
    test 'bad login' do
      u = User.make! login: 'johnqpublic', password: 'e7(2DZME', password_confirmation: 'e7(2DZME'
      visit '/'
      assert_logged_out
      click_link 'Log in'
      within 'form.new_user_session' do
        fill_in 'user_session_login', with: 'jane'
        fill_in 'user_session_password', with: 'e7(2DZME'
        click_button 'Log in'
      end
      assert_text 'Incorrect login or password'
      assert_logged_out
    end
  else
    test 'bad email' do
      u = User.make! email: 'johnqpublic@example.com', password: 'e7(2DZME', password_confirmation: 'e7(2DZME'
      visit '/'
      assert_logged_out
      click_link 'Log in'
      within 'form.new_user_session' do
        fill_in 'user_session_email', with: 'jane@example.com'
        fill_in 'user_session_password', with: 'e7(2DZME'
        click_button 'Log in'
      end
      assert_text 'Incorrect email or password'
      assert_logged_out
    end
  end
  
  test 'bad password' do
    u = User.make! email: 'johnqpublic@example.com', password: 'e7(2DZME', password_confirmation: 'e7(2DZME'
    visit '/'
    assert_logged_out
    click_link 'Log in'
    within 'form.new_user_session' do
      fill_login_field u
      fill_in 'user_session_password', with: 'tP4J[s8P'
      click_button 'Log in'
    end
    if User.has_login_field?
      assert_text 'Incorrect login or password'
    else
      assert_text 'Incorrect email or password'
    end
    assert_logged_out
  end
  
  test 'not activated' do
    u = User.make! activated: false, email: 'johnqpublic@example.com', password: 'e7(2DZME', password_confirmation: 'e7(2DZME'
    visit '/'
    assert_logged_out
    click_link 'Log in'
    within 'form.new_user_session' do
      fill_login_field u
      fill_in 'user_session_password', with: 'e7(2DZME'
      click_button 'Log in'
    end
    assert_text 'Your account has not been activated'
    assert_logged_out
  end
  
  test 'log out' do
    login
    assert_logged_in
    click_link 'Log out'
    assert_logged_out
  end
end