# frozen_string_literal: true

require "draftjs_html"
require 'pry-byebug'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { require _1 }
require 'draftjs_html/spec_support/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include DraftjsHtml::SpecSupport::RSpecMatchers
end
