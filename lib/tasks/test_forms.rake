require 'rake/testtask'
namespace :test do
  Rake::TestTask.new(forms: 'test:prepare') do |t|
    t.pattern = 'test/forms/*_test.rb'
  end
end