require 'machinist/active_record'

User.blueprint do
  activated { true }
  if User.has_login_field?
    login { Faker::Lorem.words(3).join('_').downcase }
  end
  email { Faker::Internet.email }
  password { 'j4Fu%nA!' }
  password_confirmation { 'j4Fu%nA!' }
end