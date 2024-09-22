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
            @x = TOPLEVEL_BINDING
          end
        end
      RUBY
    end

    specify do
      expect_no_offenses(<<~RUBY)
        class SomeClass
          def initialize(app)
            @app = app
            @user = User.new
          end

          def call(env, user)
            @x = TOPLEVEL_BINDING
          end
        end
      RUBY
    end
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class TestMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        end
      end
    RUBY
  end

  it 'registers an offense' do
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

  it 'registers an offense with mismatched local and instance variables' do
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

  it 'registers an offense for nested middleware' do
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

  it 'registers an offense for multiple middlewares' do
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

  it 'registers an offense for extra methods' do
    expect_offense(<<~RUBY)
      class TestMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
          @a = 1
          ^^^^^^ #{msg}
        end

        def foo
          @a = 1
          ^^^^^^ #{msg}
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      class TestMiddleware
        def foo
          @a = 1
          ^^^^^^ #{msg}
        end

        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      class TestMiddleware
        def foo
          @a = 1
          ^^^^^^ #{msg}
        end

        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        end

        def bar
          @b = 1
          ^^^^^^ #{msg}
        end
      end
    RUBY
  end

  it 'registers an offense with `call` before constructor definition' do
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

  context 'with `instance_variable_set` and `instance_variable_get` methods' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class TestMiddleware
          def initialize(app)
            @app = app
            instance_variable_set(:counter, 1)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid instance variables in rack middleware.
          end

          def call(env)
            @app.call(env)
            instance_variable_get(:@counter)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid instance variables in rack middleware.
          end
        end
      RUBY
    end
  end
end
