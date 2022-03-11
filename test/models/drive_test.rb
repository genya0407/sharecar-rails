class DriveTest < ActiveSupport::TestCase
  test '.in start_atかcreated_atで絞りこめること' do
    create(:drive, start_at_transient: Time.zone.now)
    create(:drive, start_at_transient: Time.zone.now + 10.days)
    create(:drive, start_at: nil, end_at: nil, created_at: Time.zone.now + 3.hours)

    assert_equal Drive.in(Time.zone.now - 10.hours, Time.zone.now + 10.hours).count, 2
  end

  test '.last_meter 最後に終了したメーターの値が取得できること' do
    car = create(:car)
    drive = create(:drive, car: car)

    assert_equal Drive.last_meter(car), drive.end_meter
  end

  test 'last_meterよりも小さい値をstart_meterに指定して作成できること' do
    last_drive = create(:drive)
    drive = build(:drive_from_start_at,
                  start_at: last_drive.end_at + rand(2..5).hours,
                  start_meter: rand(0..(last_drive.end_meter)),
                  end_meter: nil,
                  car: last_drive.car)
    assert drive.valid?
  end

  test '.lack_exist? meterに欠けがないときfalseを返すこと' do
    car = create(:car)
    create(:drive, car: car, start_meter: 100, end_meter: 200)
    create(:drive, car: car, start_meter: 200, end_meter: 300)

    assert_not car.drives.reload.lack_exist?
  end

  test '.lack_exist? meterに欠けがあるときtrueを返すこと' do
    car = create(:car)
    create(:drive, car: car, start_meter: 100, end_meter: 200)
    create(:drive, car: car, start_meter: 201, end_meter: 300)

    assert car.drives.reload.lack_exist?
  end
end
