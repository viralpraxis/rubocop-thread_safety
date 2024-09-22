# frozen_string_literal: true

RSpec.describe RuboCop::Cop::ThreadSafety::RackMiddlewareInstanceVariable, :config do
  let(:msg) { 'Avoid instance variables in rack middleware.' }

  context 'with unrelated source' do
    it { expect_no_offenses '' }

    specify do
      expect_no_offenses(<<~RUBY)
        class SomeClass
          def initialize(user)
            @user = user
          end
        end
      RUBY
    end

    specify do
      expect_no_offenses(<<~RUBY)
        class SomeClass
          def initialize(user, context)
            @user = user
            @context = context
          end
        end
      RUBY
    end

    specify do
      expect_no_offenses(<<~RUBY)
        class SomeClass
          def initialize(user, context)
            @user = user
            @context = context
          end

          def call
            [@user, @context]
          end
        end
      RUBY
    end

    specify do
      expect_no_offenses(<<~RUBY)
        class SomeClass
          def initialize(user, context)
            @user = user
            @context = context
          end

          def call(env)
            [@user, @context]
          end
        end
      RUBY
    end

    specify do
      expect_no_offenses(<<~RUBY)
        class SomeClass
          def initialize(app)
            @user = User.new
          end

          def call(env)
            TOPLEVEL_BINDING
          end
        end
      RUBY
    end
  end

  it 'registers an offense' do # rubocop:disable RSpec/ExampleLength
    expect_offense(<<~RUBY)
      class TestMiddleware
        def initialize(app)
          @app = app
          @foo = 1
          ^^^^^^^^ #{msg}
        end

        def call(env)
          @app.call(env)
        end
      end
    RUBY
  end

  it 'registers an offense with mismatched local and instance variables' do # rubocop:disable RSpec/ExampleLength
    expect_offense(<<~RUBY)
      class TestMiddleware
        def initialize(app)
          @foo = fsa
          ^^^^^^^^^^ #{msg}
          @a = app
        end

        def call(env)
          @a.call(env)
        end
      end
    RUBY
  end

  it 'registers an offense for nested middleware' do # rubocop:disable RSpec/ExampleLength
    expect_offense(<<~RUBY)
      module MyMiddlewares
        class TestMiddleware
          def initialize(app)
            @app = app
            @foo = 1
            ^^^^^^^^ #{msg}
          end

          def call(env)
            @app.call(env)
          end
        end
      end
    RUBY
  end

  it 'registers an offense for multiple middlewares' do # rubocop:disable RSpec/ExampleLength
    expect_offense(<<~RUBY)
      module MyMiddlewares
        class TestMiddleware
          def initialize(app)
            @app = app
            @foo = 1
            ^^^^^^^^ #{msg}
          end

          def call(env)
            @app.call(env)
          end
        end

        class TestMiddleware2
          def initialize(app)
            @app = app
            @foo = 1
            ^^^^^^^^ #{msg}
          end

          def call(env)
            @app.call(env)
          end
        end
      end
    RUBY
  end

  it 'registers an offense with `call` before constructor definition' do # rubocop:disable RSpec/ExampleLength
    expect_offense(<<~RUBY)
      class TestMiddleware
        def call(env)
          @app.call(env)
        end

        def initialize(app)
          @app = app
          @foo = 1
          ^^^^^^^^ #{msg}
        end
      end
    RUBY
  end
end
