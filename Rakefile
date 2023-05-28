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
  task.cucumber_opts = ['features', '--publish-quiet', '--tags \'not @wip\'']
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color --format d'
end

namespace :db do
  task :migrate do
    require 'sequel'
    require_relative 'config/configuration'
    Sequel.extension :migration
    logger = Configuration.logger
    db = Configuration.db
    db.loggers << logger
    logger.info('asdasd')
    Sequel::Migrator.run(db, 'db/migrations')
    puts '<= sq:migrate:up executed'
  end
end

task default: %i[cucumber spec rubocop]

# https://gist.github.com/obfuscurity/1409152
# desc "Perform migration up to latest migration available"
