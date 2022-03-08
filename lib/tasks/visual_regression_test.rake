namespace :visual_regression_test do
  task take_screenshot: :environment do
    output_dir = ENV['OUTPUT_DIR'] || 'tmp/visual_regression_test'
    FileUtils.mkdir_p(output_dir)
    scenario = VisualRegressionTest::Scenario.new(output_dir: output_dir)
    scenario.execute
  end

  task compare: :environment do
    before_dir = ENV.fetch('BEFORE')
    after_dir = ENV.fetch('AFTER')
    compare_dir = ENV.fetch('OUTPUT')
    FileUtils.mkdir_p(compare_dir)

    Dir.glob(File.join(after_dir, '*')).each do |entry|
      filename = File.basename(entry)
      before_file = File.join(before_dir, filename)
      after_file = File.join(after_dir, filename)
      next if File.read(before_file) == File.read(after_file)

      compare_file = File.join(compare_dir, filename)
      system("compare #{after_file} #{before_file} #{compare_file}")
    end
  end
end
