def _system(cmd, exception: true)
  puts "[CMD]: #{cmd}"
  system(cmd, exception: exception)
end

def fork_run_block
  pid = fork do
    yield
  end

  _, status = Process.wait2(pid)
  raise "Process exited with status code: #{status.exitstatus}. at #{caller.first}" unless status.success?
end

namespace :visual_regression_test do
  task take_screenshot: :environment do
    output_dir = ENV['OUTPUT_DIR'] || 'tmp/visual_regression_test'
    freeze_time_at = ENV['FREEZE_TIME_AT'].to_i || Time.zone.now.to_i
    FileUtils.mkdir_p(output_dir)
    scenario = VisualRegressionTest::Scenario.new(output_dir: output_dir, freeze_time_at: freeze_time_at)
    scenario.execute
  end

  task compare: :environment do
    before_dir = ENV.fetch('BEFORE_DIR')
    after_dir = ENV.fetch('AFTER_DIR')
    compare_dir = ENV.fetch('OUTPUT_DIR')
    FileUtils.mkdir_p(compare_dir)

    Dir.glob(File.join(after_dir, '*')).each do |entry|
      filename = File.basename(entry)
      before_file = File.join(before_dir, filename)
      after_file = File.join(after_dir, filename)
      next if File.read(before_file) == File.read(after_file)

      compare_file = File.join(compare_dir, filename)
      _system("compare #{after_file} #{before_file} #{compare_file}", exception: false)
    end
  end

  task run: :environment do
    current_branch = `git rev-parse --abbrev-ref HEAD`.strip
    current_ref = `git rev-parse HEAD`.strip
    base_branch = ENV.fetch('BASE_BRANCH', 'master').strip
    base_ref = `git rev-parse #{base_branch}`.strip
    freeze_time_at = Time.zone.now.to_i

    before_dir = File.join('tmp', "visual_regression_test_auto_#{base_ref}")
    after_dir = File.join('tmp', "visual_regression_test_auto_#{current_ref}")
    compare_dir = File.join('tmp', 'visual_regression_test_auto_compare')

    fork_run_block do
      ENV['OUTPUT_DIR'] = after_dir
      ENV['FREEZE_TIME_AT'] = freeze_time_at.to_s
      Rake::Task['visual_regression_test:take_screenshot'].invoke
    end

    fork_run_block do
      _system("git checkout #{base_branch}")
      _system('bundle install')

      ENV['OUTPUT_DIR'] = before_dir
      ENV['FREEZE_TIME_AT'] = freeze_time_at.to_s
      Rake::Task['visual_regression_test:take_screenshot'].invoke
    ensure
      _system("git checkout #{current_branch}")
    end

    fork_run_block do
      ENV['BEFORE_DIR'] = before_dir
      ENV['AFTER_DIR'] = after_dir
      ENV['OUTPUT_DIR'] = compare_dir

      Rake::Task['visual_regression_test:compare'].invoke
    end
  end
end
