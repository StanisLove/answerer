require_relative 'rails_helper'
require 'capybara/email/rspec'
require 'rack_session_access/capybara'
require 'capybara/poltergeist'
require 'rspec/page-regression'
require 'bg_helper' unless Nenv.skip_bg?

RSpec.configure do |config|
  Capybara.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i
  Capybara.server_host = "0.0.0.0"

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      timeout: 90, js_errors: true,
      phantomjs_logger: Logger.new(STDOUT),
      window_size: [1020, 740]
    )
  end

  Capybara.javascript_driver = :poltergeist

  RSpec::PageRegression.configure do |c|
    c.threshold = 0.01
  end

  config.include AcceptanceHelper, type: :feature
  config.include WaitForAjax,      type: :feature
  config.include OmniauthMacros,   type: :feature
  config.include SphinxHelpers,    type: :feature

  config.use_transactional_fixtures = false
  # Database Cleaner config
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :truncation
    # Sphinx Index data when running an acceptance spec.
    index
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

OmniAuth.config.test_mode = true
