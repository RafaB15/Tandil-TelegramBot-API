require 'bundler/setup'

ENV['APP_ENV'] ||= 'test'

task :version do
  require './lib/version'
  puts Version.current
  exit 0
end

namespace :db do
  require 'sequel'
  require_relative 'config/configuration'
  Sequel.extension :migration
  desc 'Run migrations'
  task :migrate do |_t|
    logger = Configuration.logger
    db = Configuration.db
    db.loggers << logger
    Sequel::Migrator.run(db, 'db/migrations')
    puts '<= sq:migrate:up executed'
  end
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--display-cop-names']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber) do |task|
  task.cucumber_opts = ['features', '--publish-quiet', '--tags \'not @wip\'']
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = '--color --format d'
end

task default: %i[cucumber spec rubocop]

# https://gist.github.com/obfuscurity/1409152
# desc "Perform migration up to latest migration available"
