require 'controllers/base'

class Metrics::DriveControllerTest < BaseControllerTest
  test 'should be admin' do
    login

    get metrics_drives_path
    assert_response :found
  end

  test 'status ok' do
    user = login
    user.admin!

    get metrics_drives_path
    assert_response :ok
  end
end
