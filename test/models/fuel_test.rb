require 'test_helper'

class FuelTest < ActiveSupport::TestCase
  test '.in created_atでフィルタできること' do
    create(:fuel, created_at: Time.zone.now)
    create(:fuel, created_at: Time.zone.now + 10.days)

    assert Fuel.in(Time.zone.now - 10.hours, Time.zone.now + 10.hours).count == 1
  end
end
