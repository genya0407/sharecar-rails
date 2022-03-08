module VisualRegressionTest
  class Scenario
    class Admin
      def initialize(browser)
        @browser = browser
      end

      def execute
        admin_cars
        admin_car_edit
        admin_fuels
        admin_drivings
      end

      private

      def admin_drivings
        @browser.go_to('/admin/cars/1/drives')
        @browser.screenshot('admin_drivings')
      end

      def admin_fuels
        @browser.go_to('/admin/cars/1/fuels')
        @browser.screenshot('admin_fuels')

        @browser.at_xpath("//i[text() = 'add']").click
        @browser.screenshot('admin_fuel_add')

        @browser.at_css('.select-dropdown').focus.click
        @browser.screenshot('admin_fuel_add_select_user')
        @browser.click_rotated(x: 1, y: -1)

        @browser.at_css('.datepicker').focus.click
        @browser.screenshot('admin_fuel_date_picker')
        @browser.click_rotated(x: 1, y: -1)
      end

      def admin_car_edit
        @browser.go_to('/admin/cars/1/edit')
        @browser.screenshot('admin_car_edit')
      end

      def admin_cars
        @browser.go_to('/admin/cars')
        @browser.screenshot('admin_cars')
      end
    end
  end
end
