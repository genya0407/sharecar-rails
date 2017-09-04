require 'active_support/concern'

CHECK_START_AT = Time.zone.local(2017, 7, 1).freeze # ちゃんと使い始めた日

module OnlyChecked
  extend ActiveSupport::Concern

  included do |base|
    scope :only_checked, -> { where('created_at >= ?', CHECK_START_AT) }
  end
end