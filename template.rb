# Example usage:
# rm -rf hq_rails && rails new hq_rails -m ~/gems/hq_rails_template/template.rb --skip-bundle

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def config(env, variable, value)
  pattern = /config\.#{Regexp.escape(variable)} += +.+/
  path = File.join('config/environments', "#{env}.rb")
  src = File.read path
  if src.match pattern
    src.sub! pattern, "config.#{variable} = #{value}"
    File.open(path, 'w') do |f|
      f << src
    end
  else
    environment "config.#{variable} = #{value}", env: env
  end
end

['development', 'test'].each do |env|
  config env, 'active_support.deprecation', ':raise'
  config env, 'action_controller.action_on_unpermitted_parameters', ':raise'
end

environment(%Q(
  config.middleware.use(ExceptionNotification::Rack,
    email: {
      email_prefix: "Number Stories ",
      sender_address: %{"Exception Notifier" <noreply@skynetjuniorscholars.org>},
      exception_recipients: ['jarrettcolby@gmail.com'],
    },
    ignore_crawlers: ['Yandex', 'Googlebot']
  )
), env: 'production')

copy_file 'Gemfile', force: true

template 'config/database.yml', force: true
template 'config/routes.rb', force: true

copy_file 'db/migrate/00000000000001_create_users.rb'
copy_file 'db/migrate/00000000000002_create_echo_uploads_files.rb'

copy_file 'app/models/user.rb', force: true
copy_file 'app/models/user_session.rb', force: true

copy_file 'app/mailers/user_mailer.rb', force: true

copy_file 'app/controllers/application_controller.rb', force: true
copy_file 'app/controllers/static_controller.rb', force: true
copy_file 'app/controllers/users_controller.rb', force: true
copy_file 'app/controllers/user_sessions_controller.rb', force: true

copy_file 'app/helpers/application_helper.rb', force: true

copy_file 'app/views/layouts/application.html.erb', force: true
copy_file 'app/views/users/new.html.erb', force: true
copy_file 'app/views/users/edit.html.erb', force: true
copy_file 'app/views/users/_password_strength_instructions.html.erb', force: true
copy_file 'app/views/user_sessions/new.html.erb', force: true
copy_file 'app/views/user_mailer/email_confirmation.html.erb', force: true
copy_file 'app/views/user_mailer/email_confirmation.text.erb', force: true
copy_file 'app/views/static/home.html.erb', force: true

copy_file 'app/assets/stylesheets/application.css', force: true
copy_file 'app/assets/javascripts/application.js', force: true
copy_file 'app/assets/javascripts/notice.js', force: true

copy_file 'test/test_helper.rb', force: true
copy_file 'test/blueprints.rb', force: true
copy_file 'test/models/user_test.rb', force: true
copy_file 'test/integration/log_in_test.rb', force: true
copy_file 'test/integration/account_test.rb', force: true

file 'echo_uploads/development/.gitignore', "*\n!.gitignore"
file 'echo_uploads/test/.gitignore', "*\n!.gitignore"