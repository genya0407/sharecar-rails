module VisualRegressionTest
  class Scenario
    class Driving
      def initialize(browser)
        @browser = browser
      end

      def execute
        @browser.go_to('/')
        @browser.at_xpath("//i[text() = 'send']").click

        @browser.at_css("input[name='drive_form_create[end_at_date]']").focus
        @browser.screenshot('driving_start_click')

        @browser.click_rotated(x: 1, y: -1)
        @browser.screenshot('driving_start_focus_off')

        # 普通に focus type すると modal に邪魔されて値が入らないので javascript で無理やり入れる
        @browser.evaluate(%{document.querySelector("input[name='drive_form_create[end_at_date]']").value = "2040-03-01"})
        @browser.screenshot('driving_input')

        @browser.at_css('input[type=submit]').click
        @browser.screenshot('drive_started')

        @browser.at_xpath("//i[text() = 'done']").click
        @browser.screenshot('drive_end')

        @browser.at_css('input[type=submit]').click
        @browser.screenshot('drive_end_executed')
      end
    end
  end
end
