# frozen_string_literal: true

unless RuboCop::Version.version >= '1.6'
  RSpec.shared_context 'ruby 2.7' do
    # Prism supports parsing Ruby 3.3+.
    let(:ruby_version) { ENV['PARSER_ENGINE'] == 'parser_prism' ? 3.3 : 2.7 }
  end

  RSpec.shared_context 'ruby 3.0' do
    # Prism supports parsing Ruby 3.3+.
    let(:ruby_version) { ENV['PARSER_ENGINE'] == 'parser_prism' ? 3.3 : 3.0 }
  end

  RSpec.shared_context 'ruby 3.1' do
    # Prism supports parsing Ruby 3.3+.
    let(:ruby_version) { ENV['PARSER_ENGINE'] == 'parser_prism' ? 3.3 : 3.1 }
  end

  RSpec.shared_context 'ruby 3.2' do
    # Prism supports parsing Ruby 3.3+.
    let(:ruby_version) { ENV['PARSER_ENGINE'] == 'parser_prism' ? 3.3 : 3.2 }
  end

  RSpec.shared_context 'ruby 3.3' do
    let(:ruby_version) { 3.3 }
  end

  RSpec.shared_context 'ruby 3.4' do
    let(:ruby_version) { 3.4 }
  end
end
