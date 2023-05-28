# rubocop:disable all
require 'spec_helper'
require_relative '../config/configuration'

RSpec.configure do |config|
  config.before :suite do
    DB = Configuration.db
  end

  config.after :each do
    RepositorioUsuarios.new.delete_all
  end
end
