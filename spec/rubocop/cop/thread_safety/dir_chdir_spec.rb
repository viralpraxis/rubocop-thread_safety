# frozen_string_literal: true

RSpec.describe RuboCop::Cop::ThreadSafety::DirChdir, :config do
  let(:msg) { 'Avoid using `Dir.chdir` due to its process-wide effect.' }

  context 'with `Dir.chdir` method' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Dir.chdir("/var/run")
        ^^^^^^^^^^^^^^^^^^^^^ #{msg}
      RUBY
    end

    it 'registers an offense when called without arguments' do
      expect_offense(<<~RUBY)
        Dir.chdir
        ^^^^^^^^^ #{msg}
      RUBY
    end

    it 'registers an offense with top-level constant' do
      expect_offense(<<~RUBY)
        ::Dir.chdir("/var/run")
        ^^^^^^^^^^^^^^^^^^^^^^^ #{msg}
      RUBY
    end
  end

  context 'with another `Dir` class method' do
    it 'does not register an offense' do
      expect_no_offenses 'Dir.pwd'
    end
  end

  context 'when received is not `Dir`' do
    it 'does not register an offense' do
      expect_no_offenses 'chdir("/tmp")'
    end
  end
end
