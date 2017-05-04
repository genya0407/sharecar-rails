class Bill < ApplicationRecord
  belongs_to :term
  belongs_to :user

  validation :term, presence: true
  validation :user, presence: true
  validation :amount, presence: true

  def paid!
    update!(paid_at: Time.zone.now)
  end

  def paid?
    paid_at.present?
  end
end
