require 'test_helper'

class DriveFormCreateTest < ActiveSupport::TestCase
  test 'start_atとend_atが無くても作成できること' do
    start_meter = rand(100..10_000)
    form = DriveForm::Admin.new(
      start_meter: start_meter,
      end_meter: start_meter + rand(10..100),
      user_id: create(:user).id,
      car_id: create(:car).id
    )

    assert form.valid?

    assert_difference 'Drive.count', +1 do
      form.save!
    end
  end
end
