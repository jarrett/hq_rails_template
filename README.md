# HQ Rails Template

This is a custom Rails template. It provides a nice starting point for a Rails project.
It uses Rails' built-in application template system, which itself is largely based on
[Thor](https://github.com/erikhuda/thor).

## Usage

    rails new hq_rails -m ~/gems/hq_rails_template/template.rb

## Features

* [Rails 4](https://github.com/rails/rails)
* [Bootstrap](https://github.com/twbs/bootstrap-sass)
* [Authlogic](https://github.com/binarylogic/authlogic) (logins, configured for Bcrypt)
* [Authlogic Email Token] (https://github.com/jarrett/authlogic_email_token)
  (password resets, account activation)
* [Echo Uploads](https://github.com/jarrett/echo_uploads) (user-uploaded files)
* [Exception Notification](https://github.com/smartinez87/exception_notification)
  (sends emails when an exception is raised in production)

## Test Framework

* [MiniTest](https://github.com/seattlerb/minitest)
* [MiniTest Reporters](https://github.com/kern/minitest-reporters)
* [Capybara](https://github.com/jnicklas/capybara)
* [Capybara Email](https://github.com/dockyard/capybara-email)
* [Poltergeist](https://github.com/teampoltergeist/poltergeist)
* [Machinist](https://github.com/notahat/machinist)
* [Faker](https://github.com/stympy/faker)
* [Mocha](https://github.com/freerange/mocha)
* [Timecop](https://github.com/travisjeffery/timecop)