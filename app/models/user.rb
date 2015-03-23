class User < ActiveRecord::Base
  has_many :questions
  validates_presence_of :user_name
  validates_presence_of :user_email

  attr_accessor :password
  validates_confirmation_of :password
  before_create :encrypt_password

  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def self.authenticate(email, password)
    user = User.where(email: email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

end
