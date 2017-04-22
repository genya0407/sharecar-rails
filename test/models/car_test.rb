require 'test_helper'

class CarTest < ActiveSupport::TestCase
  setup do
    @car = create(:car)
    3.times { create(:drive, car: @car) }
  end

  # 使用中のdrive: end_meterがnilのdrive

  # occupied?
  test '使用中のdriveがある時、car#occupied?がtrueになること' do
    create(:drive_not_end, car: @car)

    assert @car.occupied?
  end

  test 'すべてのdrive使用中でないとき、car#occupied?がfalseになること' do
    assert_not @car.occupied?
  end

  test '別のcarについて使用中のdriveがあっても、car#occupied?がfalseになること' do
    create(:drive_not_end)

    assert_not @car.occupied?
  end

  # current_drive
  test '使用中のdriveがある時、current_driveによってそのdriveが取得できること' do
    drive = create(:drive_not_end, car: @car)

    assert_equal drive.id, @car.current_drive.id
  end

  test '複数の使用中のdriveがある時、current_driveによって、一番新しいdriveが取得できること' do
    3.times { create(:drive_not_end, car: @car) }
    drive = create(:drive_not_end, car: @car)

    assert_equal drive.id, @car.current_drive.id
  end

  # current_driver
  test '使用中のdriveがある時、current_driverによって使用中のuserが取得できること' do
    user = create(:user)
    drive = create(:drive_not_end, car: @car, user: user)

    assert_equal @car.current_driver.id, drive.user.id
  end

  # using_drive
  test '自分が使用するdriveがある時、using_driveによってそのdriveが取得できること' do
    user = create(:user)
    drive = create(:drive_not_end, car: @car, user: user)

    assert_equal @car.using_drive(user).id, drive.id
  end

  # using?
  test '自分が使用するdriveがある時、using?がtrueになること' do
    user = create(:user)
    drive = create(:drive_not_end, car: @car, user: user)

    assert @car.using?(user)
  end

  test '自分が使用するdriveが無い時、using?がfalseになること' do
    user = create(:user)
    drive = create(:drive_not_end, car: @car)

    assert_not @car.using?(user)
  end
end
