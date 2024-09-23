# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/spec'

  enable_coverage :branch
end

begin
  require 'pry'
rescue LoadError
  # Pry isn't installed in CI.
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'rubocop-thread_safety'

require 'rubocop/rspec/support'

RSpec.configure do |config|
  config.include RuboCop::RSpec::ExpectOffense

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  if ENV.key? 'CI'
    config.before(:example, :focus) { raise 'Should not commit focused specs' }
  else
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
    config.fail_fast = ENV.key? 'RSPEC_FAIL_FAST'
  end

  config.filter_run_excluding unsupported_on: :prism if ENV['PARSER_ENGINE'] == 'parser_prism'

  config.disable_monkey_patching!

  config.order = :random

  Kernel.srand config.seed

  config.include_context 'ruby 2.7', :ruby27
  config.include_context 'ruby 3.0', :ruby30
  config.include_context 'ruby 3.1', :ruby31
  config.include_context 'ruby 3.2', :ruby32
  config.include_context 'ruby 3.3', :ruby33
  config.include_context 'ruby 3.4', :ruby34
end
