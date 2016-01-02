ENV['RAILS_ENV'] ||= 'test'

$LOAD_PATH << File.expand_path("spec/lib")

require File.expand_path('../../spec/dummy/config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'capybara/email/rspec'

%w{fabricators support}.each do |directory|
  Dir[File.expand_path("spec/#{directory}/**/*.rb")].each { |file| require file }
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
end
