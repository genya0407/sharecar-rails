def _system(cmd, exception: true)
  puts "[CMD]: #{cmd}"
  system(cmd, exception: exception)
end

namespace :visual_regression_test do
  task take_screenshot: :environment do
    output_dir = ENV['OUTPUT_DIR'] || 'tmp/visual_regression_test'
    FileUtils.mkdir_p(output_dir)
    scenario = VisualRegressionTest::Scenario.new(output_dir: output_dir)
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
    
    before_dir = File.join('tmp', "visual_regression_test_auto_#{base_ref}")
    after_dir = File.join('tmp', "visual_regression_test_auto_#{current_ref}")
    compare_dir = File.join('tmp', "visual_regression_test_auto_compare")

    fork do
      ENV['OUTPUT_DIR'] = after_dir
      Rake::Task['visual_regression_test:take_screenshot'].invoke
    end.tap { |pid| Process.wait pid }

    fork do
      _system("git checkout #{base_branch}")
      _system('bundle install')

      ENV['OUTPUT_DIR'] = before_dir
      Rake::Task['visual_regression_test:take_screenshot'].invoke
    ensure
      _system("git checkout #{current_branch}")
    end.tap { |pid| Process.wait pid }

    fork do
      ENV['BEFORE_DIR'] = before_dir
      ENV['AFTER_DIR'] = after_dir
      ENV['OUTPUT_DIR'] = compare_dir

      Rake::Task['visual_regression_test:compare'].invoke
    end.tap { |pid| Process.wait pid }
  end
end
