require 'securerandom'

class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :key, uniqueness: true, allow_nil: false
  validates :account_key, uniqueness: true, allow_nil: true
  validates :phone_number, uniqueness: true

  has_secure_password

  before_validation :generate_key

  def generate_key
    self.key = SecureRandom.uuid if self.key.nil?
  end
end
