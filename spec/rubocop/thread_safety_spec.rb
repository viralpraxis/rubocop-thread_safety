# frozen_string_literal: true

RSpec.describe RuboCop::ThreadSafety do
  it 'has a version number' do
    expect(RuboCop::ThreadSafety::Version::STRING).to match(/\d+\.\d+.\d+/)
  end
end
