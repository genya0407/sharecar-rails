def _system(cmd, exception: true)
  puts "[CMD]: #{cmd}"
  system(cmd, exception:)
end

def take_screenshot(output_dir:, freeze_time_at: Time.zone.now.to_i)
  FileUtils.mkdir_p(output_dir)
  scenario = VisualRegressionTest::Scenario.new(output_dir:, freeze_time_at:)
  scenario.execute
end

def compare_screenshot(before_dir:, after_dir:, compare_dir:)
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

def combine(before_dir:, after_dir:, compare_dir:, combined_dir:)
  FileUtils.mkdir_p(combined_dir)

  Dir.glob(File.join(compare_dir, '*')).each do |path|
    entry = File.basename path
    _system("convert +append #{File.join(before_dir, entry)} #{File.join(after_dir, entry)} #{File.join(compare_dir, entry)} #{File.join(combined_dir, entry)}", exception: false)
  end
end

namespace :visual_regression_test do
  task run: :environment do
    raise 'git diff exists' unless `git status --porcelain`.strip.lines.empty?

    current_branch = `git rev-parse --abbrev-ref HEAD`.strip
    current_ref = `git rev-parse HEAD`.strip
    base_branch = ENV.fetch('BASE_BRANCH', 'master').strip
    base_ref = `git rev-parse #{base_branch}`.strip
    freeze_time_at = Time.zone.now.to_i

    before_dir = File.join('tmp', 'visual_regression_test_auto', base_ref.to_s)
    after_dir = File.join('tmp', 'visual_regression_test_auto', current_ref.to_s)
    compare_dir = File.join('tmp', 'visual_regression_test_auto', 'compare')
    combined_dir = File.join('tmp', 'visual_regression_test_auto', 'combined')

    _system('rm -rf tmp/visual_regression_test_auto')

    take_screenshot(output_dir: after_dir, freeze_time_at:)

    begin
      _system("git checkout #{base_branch}")
      _system('bundle install')
      take_screenshot(output_dir: before_dir, freeze_time_at:)
    ensure
      _system("git checkout #{current_branch}")
    end

    compare_screenshot(before_dir:, after_dir:, compare_dir:)

    combine(before_dir:, after_dir:, compare_dir:, combined_dir:)
  end
end
