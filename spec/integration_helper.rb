# rubocop:disable all
require 'spec_helper'
require_relative '../config/configuration'

RSpec.configure do |config|
  config.before :suite do
    DB = Configuration.db
    Sequel.extension :migration
    logger = Configuration.logger
    db = Configuration.db
    db.loggers << logger
    Sequel::Migrator.run(db, 'db/migrations')
  end

  config.after :each do
    AbstractRepository.subclasses.each do |repositorio|
      repositorio.new.delete_all
    end
  end
end
