# frozen_string_literal: true

RSpec.describe RuboCop::Cop::ThreadSafety::NewThread, :config do
  let(:msg) { 'Avoid starting new threads.' }

  it 'registers an offense for starting a new thread' do
    expect_offense(<<~RUBY)
      Thread.new { do_work }
      ^^^^^^^^^^ #{msg}
    RUBY
  end

  it 'registers an offense for starting a new thread with positional arguments' do
    expect_offense(<<~RUBY)
      Thread.new(1) { do_work }
      ^^^^^^^^^^^^^ #{msg}
    RUBY
  end

  it 'registers an offense for starting a new thread with keyword arguments' do
    expect_offense(<<~RUBY)
      Thread.new(a: 42) { do_work }
      ^^^^^^^^^^^^^^^^^ #{msg}
    RUBY
  end

  it 'registers an offense for starting a new thread with `fork` method' do
    expect_offense(<<~RUBY)
      Thread.fork { do_work }
      ^^^^^^^^^^^ #{msg}
    RUBY
  end

  it 'registers an offense for starting a new thread with `start` method' do
    expect_offense(<<~RUBY)
      Thread.start { do_work }
      ^^^^^^^^^^^^ #{msg}
    RUBY
  end

  it 'registers an offense for starting a new thread with top-level constant' do
    expect_offense(<<~RUBY)
      ::Thread.new { do_work }
      ^^^^^^^^^^^^ #{msg}
    RUBY
  end

  it 'does not register an offense for calling new on other classes' do
    expect_no_offenses('Other.new { do_work }')
  end
end
