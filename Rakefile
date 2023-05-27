require 'bundler/setup'

ENV['RACK_ENV'] ||= 'test'

task :version do
  require './lib/version'
  puts Version.current
  exit 0
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--display-cop-names']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber) do |task|
  task.cucumber_opts = ['features', '--tags \'not @wip\'']
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color --format d'
end

task default: %i[cucumber spec rubocop]
