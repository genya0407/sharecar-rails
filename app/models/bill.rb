class Bill < ApplicationRecord
  belongs_to :term
  belongs_to :user

  validates :term, presence: true
  validates :user, presence: true
  validates :amount, presence: true
  validates :user, uniqueness: { scope: [:term] }

  def paid!
    update!(paid_at: Time.zone.now)
  end

  def paid?
    paid_at.present?
  end
end
