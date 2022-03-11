module VisualRegressionTest
  class Scenario
    def initialize(output_dir:, freeze_time_at:, port: 3001)
      @browser = VisualRegressionTest::Browser.new(output_dir: output_dir, port: port)
      @port = port
      @freeze_time_at = freeze_time_at
    end

    def execute
      with_server do
        login
        menu
        car_usage_history
        fuel
        Booking.new(@browser).execute
        Driving.new(@browser).execute
        user_list

        Admin.new(@browser).execute
      end

      @browser.quit
    end

    private

    def user_list
      @browser.go_to('/users/new')
      @browser.screenshot('users')
    end

    def fuel
      @browser.go_to('/')

      @browser.at_xpath("//i[text() = 'local_gas_station']").click

      @browser.at_css("input[name='fuel[amount]']").focus.type('2000')
      @browser.screenshot('fuel_input')

      @browser.at_css('input[type=submit]').click
      @browser.screenshot('fuel_history')
    end

    def car_usage_history
      @browser.go_to('/')

      @browser.at_xpath("//i[text() = 'history']").click
      @browser.screenshot('car_usage_histories')
    end

    def menu
      @browser.go_to('/')

      @browser.at_css('a[data-target=mobile]').click
      @browser.screenshot('menu_open')

      @browser.click_rotated(x: -1, y: 1)
      @browser.screenshot('menu_close')
    end

    def login
      @browser.go_to('/login')

      @browser.at_css('input[name=email]').focus.type('example@example.com')
      @browser.at_css('input[name=password]').focus.type('invalid_password')
      @browser.screenshot('login_input')

      @browser.at_css('input[type=submit]').click
      @browser.screenshot('login_failed')

      @browser.at_css('input[name=email]').focus.type('example@example.com')
      @browser.at_css('input[name=password]').focus.type('password')
      @browser.at_css('input[type=submit]').click
      @browser.screenshot('login_success')
    end

    def with_server
      system('RAILS_ENV=test bundle exec rake db:drop', exception: true)
      system('RAILS_ENV=test bundle exec rake db:setup', exception: true)
      @server_pid = spawn("RAILS_ENV=test FREEZE_TIME_AT=#{@freeze_time_at} bundle exec rails s -p #{@port} --pid=tmp/visual_regression_server.pid")
      @browser.wait_server_up('/')
      yield
    ensure
      Process.kill :INT, @server_pid if @server_pid
    end
  end
end
