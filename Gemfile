source 'https://rubygems.org'

gem 'rails', '>= 4.1.6'

gem 'mysql2'

gem 'authlogic', '>= 3.4.3'

# Authlogic extension for email confirmation tokens.
gem 'authlogic_email_token'

# As of Mar 5, 2014, there is something weird about Authlogic's dependencies. Bundler
# isn't recognizing Bcrypt as a dependenciy. So we manually include them.
gem 'bcrypt'

# Assets.
gem 'ejs'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'
gem 'uglifier'

# ExecJS needs at least one JS runtime installed, but it won't automatically install any.
gem 'therubyracer', platforms: :ruby

# File uploads.
gem 'echo_uploads'

# Validate password strength.
gem 'strong_password'

# Sends exception reports via email.
gem 'exception_notification', '= 4.1.0.rc1'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'capistrano', '2.15.5', group: :development
gem 'rvm-capistrano', '1.5.1'

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring',group: :development
end

group :test do
  # Minitest adapter.
	gem 'minitest-rails'
	
	# Prettier Minitest output.
	gem 'minitest-reporters'
	
	# Mocking framework.
	gem 'mocha'
	
	# Blueprints (fixtures alternative).
	gem 'machinist'
	gem 'faker'
	
	# Empties test database between tests.
	gem 'database_cleaner'
	
	# Go forward and back in time to test time-sensitive logic.
	gem 'timecop'
	
	# Integration testing adapters.
	gem 'capybara'
	gem 'capybara-email'
	gem 'poltergeist' # See installation instructions: https://github.com/jonleighton/poltergeist
	gem 'launchy'
end