ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require 'fileutils'

require 'rails/test_help'
require 'minitest/rails'

# Prettier test output. See https://github.com/kern/minitest-reporters/issues/121
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new, ENV, Minitest.backtrace_filter

# Integration testing framework.
require 'capybara/rails'
require 'capybara/poltergeist'

# Mocking framework.
require 'mocha/mini_test'

# Machinist blueprints.
require 'blueprints'

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, :inspector => true)
end

class ActiveSupport::TestCase
  # Transactional fixtures conflict with Poltergeist, which runs in its own thread.
  self.use_transactional_fixtures = false
  
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
  
  after do
    Capybara.use_default_driver
  end
  
  def assert_error(obj, attr, message = nil)
    obj.valid?
    assert obj.errors[attr].any?, message || "Expected error on #{attr.inspect}"
  end
  
  def assert_no_error(obj, attr, message = nil)
    obj.valid?
    assert !obj.errors[attr].any?, message || "Expected no error on #{attr.inspect}"
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Email::DSL
  
  before do
    Capybara.javascript_driver = :poltergeist
    clear_emails
  end
  
  after do
    Capybara.use_default_driver
  end
  
  def assert_logged_in(msg = 'Expected user to be logged in')
    assert has_link?('Log out'), msg
    assert has_no_link?('Log in'), msg
  end
  
  def assert_logged_out(msg = 'Expected user to be logged out')
    assert has_no_link?('Log out'), msg
    assert has_link?('Log in'), msg
  end
  
  def assert_no_email
    assert(
      ActionMailer::Base.deliveries.empty?,
      "Expected no emails to be sent, but found: #{ActionMailer::Base.deliveries.inspect}"
    )
  end
  
  def login(as = :user, options = {})
    # The default password here is the same as in blueprints.rb. So if you call User.make
    # and pass it in for the +as+ param, the passwords should match.
    options = options.reverse_merge(email: 'johndoe@example.com', password: 'j4Fu%nA!')
    options[:password_confirmation] = options[:password]
    case as
    when :user
      # Don't do anything special.
    when :staff
      options[:staff] = true
    when User
      @me = as
    else
      raise ArgumentError, "Unrecognized value passed to login: #{as.inspect}"
    end
    # If the +as+ param was a User instance, then @me is already set.
    @me ||= User.make! options
    visit '/login'
    if User.has_login_field?
      fill_in 'user_session_login', with: @me.login
    else
      fill_in 'user_session_email', with: @me.email
    end
    fill_in 'user_session_password', with: options[:password]
    click_button 'Log in'
    if User.has_login_field?
      assert_logged_in "Failed to log in with #{@me.login.inspect} and #{options[:password].inspect}"
    else
      assert_logged_in "Failed to log in with #{@me.email.inspect} and #{options[:password].inspect}"
    end
  end
  
  # This method is only compatible with Poltergeist because of the call to
  # driver.save_screenshot.
  def save_and_open_full_screenshot
    path = File.join Rails.root, 'tmp/capybara', SecureRandom.hex(8) + '.png'
    page.driver.save_screenshot path, full: true
    page.send :open_file, path
  end
end