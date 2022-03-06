module VisualRegressionTest
  class Scenario
    class Booking
      def initialize(browser)
        @browser = browser
      end

      def execute
        @browser.go_to('/')
        @browser.at_xpath("//i[text() = 'bookmark']").click

        @browser.at_css("input[name='booking_form_create[start_at_date]']").focus
        @browser.screenshot('booking_start_click')

        @browser.click_rotated(x: 1, y: -1)
        @browser.screenshot('booking_start_focus_off')

        @browser.at_css("input[name='booking_form_create[end_at_date]']").focus
        @browser.screenshot('booking_end_click')

        @browser.click_rotated(x: 1, y: -1)
        @browser.screenshot('booking_end_focus_off')

        date = '2040-03-21'
        # 普通に focus type すると modal に邪魔されて値が入らないので javascript で無理やり入れる
        @browser.evaluate(%{document.querySelector("input[name='booking_form_create[start_at_date]']").value = "#{date}"})
        @browser.evaluate(%{document.querySelector("input[name='booking_form_create[end_at_date]']").value = "#{date}"})
        # backspace と delete を2回づつ打って、確実に placeholder を消す(placeholder は二桁もしくは一桁の数字なのでこれで消える)
        @browser.at_css("input[name='booking_form_create[start_at_hour]']").focus.type(:backspace, :backspace, :delete, :delete, '10')
        @browser.at_css("input[name='booking_form_create[end_at_hour]']").focus.type(:backspace, :backspace, :delete, :delete, '20')
        @browser.screenshot('booking_input')

        @browser.at_css('input[type=submit]').click
        @browser.screenshot('booking_history')
      end
    end
  end
end
