module VisualRegressionTest
  class Browser
    def initialize(output_dir:, port:)
      @output_dir = output_dir
      @port = port
      @browser = Ferrum::Browser.new(window_size: [400, 1200])
      @screenshot_number = 0
      @used_idents = Set.new
    end

    delegate(
      :go_to,
      :at_css,
      :at_xpath,
      :quit,
      :mouse,
      :evaluate,
      to: :@browser
    )

    def screenshot(ident = nil)
      raise "#{ident.inspect} is already used." if @used_idents.include? ident

      @used_idents << ident

      # input field のカーソルが点滅することによって画像に差分が出るので、カーソルを透明にして差分が出ないようにする
      @browser.add_style_tag(content: 'body { caret-color: transparent; }')

      sleep 0.5

      filename = File.join(@output_dir, "#{format('%05d', @screenshot_number)}_#{ident}.png")
      @screenshot_number += 1

      @browser.screenshot(path: filename)
    end

    def click_rotated(x:, y:) # rubocop:disable Naming/MethodParameterName
      window_x, window_y = @browser.window_size
      @browser.mouse.click(
        x: (window_x + x) % window_x,
        y: (window_y + y) % window_y
      )
    end

    def wait_server_up(path)
      loop do
        sleep 1
        go_to(path)
        break if @browser.network.status
      end
    end

    def go_to(path)
      @browser.go_to(url(path))
    end

    def url(path)
      "http://localhost:#{@port}#{path}"
    end
  end
end
