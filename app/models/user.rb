class User < ApplicationRecord
  has_many :drives
  has_many :bookings
  has_many :bills
  has_many :fuels

  authenticates_with_sorcery!
  validates :email, presence: true, uniqueness: true
  with_options on: :create do |on_create|
    on_create.validates :password, presence: true, confirmation: true, if: :password_changed?
  end
  with_options on: :update do |on_update|
    on_update.validates :password, presence: true, confirmation: true, if: :should_check_password_on_update?
    on_update.validates :phone_number, presence: true
    on_update.validates :name, presence: true
  end

  before_create :setup_activation
  after_create :send_activation_needed_email!

  enum permission: { admin: 0, member: 5 }

  private
  def should_check_password_on_update?
    password_changed? || crypted_password.nil?
  end

  def password_changed?
    changed.include? 'crypted_password'
  end
end