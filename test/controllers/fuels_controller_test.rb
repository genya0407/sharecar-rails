require 'controllers/base'

class FuelsControllerTest < BaseControllerTest
  setup do
    login
  end

  test '給油履歴が表示されること' do
    car = create(:car)

    others_fuel_count = rand(2..5)
    others_fuel_count.times { create(:fuel, car: car) }

    my_fuel_count = rand(2..5)
    my_fuel_count.times { create(:fuel, car: car, user: @user) }

    get new_car_fuel_path(car_id: car.id)

    assert_select '.delete-fuel', my_fuel_count
    assert_select '.fuel', (others_fuel_count + my_fuel_count)
  end

  test '自分の給油履歴を削除できること' do
    car = create(:car)
    fuel = create(:fuel, car: car, user: @user)

    assert_difference 'Fuel.count', -1 do
      delete car_fuel_path(car_id: car.id, id: fuel.id)
    end
  end

  test '他人の給油履歴を削除できないこと' do
    car = create(:car)
    fuel = create(:fuel, car: car)

    assert_difference 'Fuel.count', 0 do
      delete car_fuel_path(car_id: car.id, id: fuel.id)
    end
  end
end
