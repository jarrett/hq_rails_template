class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.maintain_sessions = false
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  include Authlogic::ActsAsAuthentic::EmailToken::Confirmation
  
  has_many :folders
  has_many :uploads
  
  validates(:password, if: :require_password?,
            password_strength: {min_entropy: 15, use_dictionary: true, message: "isn't strong enough"})
  
  def activate
    self.activated = true
  end
  
  def self.find_by_login_or_email(val)
    unless has_login_field?
      raise "Trying to find_by_login_or email, but User model doesn't have login column"
    end
    where(['login = ? OR email = ?', val, val]).first
  end
  
  def self.has_login_field?
    columns.map(&:name).include?('login')
  end
end