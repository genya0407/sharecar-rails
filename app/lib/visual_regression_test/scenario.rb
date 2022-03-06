module VisualRegressionTest
  class Scenario
    def initialize(output_dir:, port: 3001)
      @browser = VisualRegressionTest::Browser.new(output_dir: output_dir)
      @port = port
    end

    def execute
      with_server do
        login
        menu
        car_usage_history
        fuel
        booking
        driving
        user_list

        admin_cars
        admin_car_edit
        admin_fuels
        admin_drivings

        @browser.quit
      end
    end

    private

    def admin_drivings
      @browser.go_to(url '/admin/cars/1/drives')
      @browser.screenshot('admin_drivings')
    end

    def admin_fuels
      @browser.go_to(url '/admin/cars/1/fuels')
      @browser.screenshot('admin_fuels')

      @browser.at_xpath("//i[text() = 'add']").click
      @browser.screenshot('admin_fuel_add')

      @browser.at_css('.select-dropdown').focus
      @browser.screenshot('admin_fuel_add_select_user')
      @browser.click_rotated(x: 1, y:-1)

      @browser.at_css('.datepicker').focus
      @browser.screenshot('admin_fuel_date_picker')
      @browser.click_rotated(x: 1, y:-1)
    end

    def admin_car_edit
      @browser.go_to(url '/admin/cars/1/edit')
      @browser.screenshot('admin_car_edit')
    end

    def admin_cars
      @browser.go_to(url '/admin/cars')
      @browser.screenshot('admin_cars')
    end

    def user_list
      @browser.go_to(url '/users/new')
      @browser.screenshot('users')
    end

    def driving
      @browser.go_to(url '/')
      @browser.at_xpath("//i[text() = 'send']").click

      @browser.at_css("input[name='drive_form_create[end_at_date]']").focus
      @browser.screenshot('driving_start_click')

      @browser.click_rotated(x: 1, y:-1)
      @browser.screenshot('driving_start_focus_off')

      # 普通に focus type すると modal に邪魔されて値が入らないので javascript で無理やり入れる
      @browser.evaluate(%Q{document.querySelector("input[name='drive_form_create[end_at_date]']").value = "2040-03-01"})
      @browser.screenshot('driving_input')

      @browser.at_css('input[type=submit]').click
      @browser.screenshot('drive_started')

      @browser.at_xpath("//i[text() = 'done']").click
      @browser.screenshot('drive_end')

      @browser.at_css('input[type=submit]').click
      @browser.screenshot('drive_end_executed')
    end

    def booking
      @browser.go_to(url '/')
      @browser.at_xpath("//i[text() = 'bookmark']").click

      @browser.at_css("input[name='booking_form_create[start_at_date]']").focus
      @browser.screenshot('booking_start_click')

      @browser.click_rotated(x: 1, y:-1)
      @browser.screenshot('booking_start_focus_off')

      @browser.at_css("input[name='booking_form_create[end_at_date]']").focus
      @browser.screenshot('booking_end_click')

      @browser.click_rotated(x: 1, y:-1)
      @browser.screenshot('booking_end_focus_off')

      date = '2040-03-21'
      # 普通に focus type すると modal に邪魔されて値が入らないので javascript で無理やり入れる
      @browser.evaluate(%Q{document.querySelector("input[name='booking_form_create[start_at_date]']").value = "#{date}"})
      @browser.evaluate(%Q{document.querySelector("input[name='booking_form_create[end_at_date]']").value = "#{date}"})
      # backspace と delete を2回づつ打って、確実に placeholder を消す(placeholder は二桁もしくは一桁の数字なのでこれで消える)
      @browser.at_css("input[name='booking_form_create[start_at_hour]']").focus.type(:backspace, :backspace, :delete, :delete, '10')
      @browser.at_css("input[name='booking_form_create[end_at_hour]']").focus.type(:backspace, :backspace, :delete, :delete, '20')
      @browser.screenshot('booking_input')

      @browser.at_css('input[type=submit]').click
      @browser.screenshot('booking_history')
    end

    def fuel
      @browser.go_to(url '/')

      @browser.at_xpath("//i[text() = 'local_gas_station']").click

      @browser.at_css("input[name='fuel[amount]']").focus.type('2000')
      @browser.screenshot('fuel_input')

      @browser.at_css("input[type=submit]").click
      @browser.screenshot('fuel_history')
    end

    def car_usage_history
      @browser.go_to(url '/')

      @browser.at_xpath("//i[text() = 'history']").click
      @browser.screenshot('car_usage_histories')
    end

    def menu
      @browser.go_to(url '/')

      @browser.at_css('a[data-activates=side-nav]').click
      @browser.screenshot('menu_open')

      @browser.click_rotated(x: -1, y: 1)
      @browser.screenshot('menu_close')
    end

    def login
      @browser.go_to(url '/login')

      @browser.at_css("input[name=email]").focus.type("example@example.com")
      @browser.at_css("input[name=password]").focus.type("invalid_password")
      @browser.screenshot('login_input')

      @browser.at_css("input[type=submit]").click
      @browser.screenshot('login_failed')

      @browser.at_css("input[name=email]").focus.type("example@example.com")
      @browser.at_css("input[name=password]").focus.type("password")
      @browser.at_css("input[type=submit]").click
      @browser.screenshot('login_success')
    end

    def url(path)
      "http://localhost:#{@port}#{path}"
    end

    def with_server
      system('RAILS_ENV=test bundle exec rake db:drop', exception: true)
      system('RAILS_ENV=test bundle exec rake db:setup', exception: true)
      @server_pid = spawn("RAILS_ENV=test bundle exec rails s -p #{@port} --pid=tmp/visual_regression_server.pid")
      @browser.wait_server_up(url '/')
      yield
    ensure
      if @server_pid
        Process.kill :INT, @server_pid
      end
    end
  end
end
