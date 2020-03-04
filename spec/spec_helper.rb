# frozen_string_literal: true

require 'bundler/setup'
require 'active_record'
require 'mysql2'
require 'armg'
require 'erbh'
require 'rspec/match_ruby'

require 'mysql_helper'

include ERBh # rubocop:disable Style/MixinUsage

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    @mysql_helper = MysqlHelper.new
    ActiveRecord::Migration.verbose = false
  end

  config.before(:each) do |example|
    @mysql_helper.reset

    @mysql_helper.create_table unless example.metadata[:skip_create_table]

    Armg.deserializer = Armg::WkbDeserializer.new
    Armg.serializer = Armg::WkbSerializer.new
  end
end
