# frozen_string_literal: true

RSpec.describe RuboCop::Cop::ThreadSafety::NewThread, :config do
  %w[new fork start].each do |method_name|
    it "registers an offense for `#{Thread}.#{method_name}`" do
      expect_offense(<<~RUBY, method_name: method_name)
        Thread.%{method_name} { do_work }
        ^^^^^^^^{method_name} Avoid starting new threads.
      RUBY
    end

    it "registers an offense for `#{Thread}.#{method_name}` with positional arguments" do
      expect_offense(<<~RUBY, method_name: method_name)
        Thread.%{method_name}(1) { do_work }
        ^^^^^^^^{method_name}^^^ Avoid starting new threads.
      RUBY
    end

    it "registers an offense for `#{Thread}.#{method_name}` with keyword arguments" do
      expect_offense(<<~RUBY, method_name: method_name)
        Thread.%{method_name}(a: 42) { do_work }
        ^^^^^^^^{method_name}^^^^^^^ Avoid starting new threads.
      RUBY
    end

    it "registers an offense for `#{Thread}.#{method_name}` with fully qualified constant name" do
      expect_offense(<<~RUBY, method_name: method_name)
        ::Thread.%{method_name}(a: 42) { do_work }
        ^^^^^^^^^^{method_name}^^^^^^^ Avoid starting new threads.
      RUBY
    end

    it "registers an offense for `#{Thread}.#{method_name}` with safe navigation" do
      expect_offense(<<~RUBY, method_name: method_name)
        Thread&.%{method_name}(a: 42) { do_work }
        ^^^^^^^^^{method_name}^^^^^^^ Avoid starting new threads.
      RUBY
    end

    it "registers an offense for `#{Thread}.#{method_name}` with block argument" do
      expect_offense(<<~RUBY, method_name: method_name)
        Thread&.%{method_name}(&block)
        ^^^^^^^^^{method_name}^^^^^^^^ Avoid starting new threads.
      RUBY
    end

    it "registers an offense for `#{Thread}.#{method_name}` with block and other arguments" do
      expect_offense(<<~RUBY, method_name: method_name)
        Thread&.%{method_name}(1, a: 42, &block)
        ^^^^^^^^^{method_name}^^^^^^^^^^^^^^^^^^ Avoid starting new threads.
      RUBY
    end

    it 'does not register an offense for unrelated receiver' do
      expect_no_offenses("Other.#{method_name} { do_work }")
    end
  end
end
