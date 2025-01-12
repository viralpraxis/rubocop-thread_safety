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

    it 'registers an offense with provided block' do
      expect_offense(<<~RUBY)
        Dir.chdir("/var/run") do
        ^^^^^^^^^^^^^^^^^^^^^ #{msg}
          puts Dir.pwd
        end
      RUBY
    end

    it 'registers an offense with provided block with argument' do
      expect_offense(<<~RUBY)
        Dir.chdir("/var/run") do |dir|
        ^^^^^^^^^^^^^^^^^^^^^ #{msg}
          puts dir
        end
      RUBY
    end

    it 'registers an offense with provided block argument' do
      expect_offense(<<~RUBY)
        def change_dir(&block)
          Dir.chdir("/var/run", &block)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{msg}
        end
      RUBY
    end
  end

  context 'with `FileUtils.chdir` method' do
    let(:msg) { 'Avoid using `FileUtils.chdir` due to its process-wide effect.' }

    it 'registers an offense' do
      expect_offense(<<~RUBY)
        FileUtils.chdir("/var/run")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{msg}
      RUBY
    end
  end

  context 'with `FileUtils.cd` method' do
    let(:msg) { 'Avoid using `FileUtils.cd` due to its process-wide effect.' }

    it 'registers an offense' do
      expect_offense(<<~RUBY)
        FileUtils.cd("/var/run")
        ^^^^^^^^^^^^^^^^^^^^^^^^ #{msg}
      RUBY
    end
  end

  context 'with another `Dir` class method' do
    it 'does not register an offense' do
      expect_no_offenses 'Dir.pwd'
    end
  end

  context 'when receiver is not `Dir`' do
    it 'does not register an offense' do
      expect_no_offenses 'chdir("/tmp")'
    end
  end

  context 'with `AllowCallWithBlock` config set to `true`' do
    let(:cop_config) do
      { 'Enabled' => true, 'AllowCallWithBlock' => true }
    end

    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Dir.chdir("/var/run")
        ^^^^^^^^^^^^^^^^^^^^^ #{msg}
      RUBY
    end

    it 'does not register an offense with provided block' do
      expect_no_offenses(<<~RUBY)
        Dir.chdir("/var/run") do
          puts Dir.pwd
        end
      RUBY
    end

    it 'does not register an offense with provided block with argument' do
      expect_no_offenses(<<~RUBY)
        Dir.chdir("/var/run") do |dir|
          puts dir
        end
      RUBY
    end

    it 'does not register an offense with provided block argument' do
      expect_no_offenses(<<~RUBY)
        def change_dir(&block)
          Dir.chdir("/var/run", &block)
        end
      RUBY
    end
  end
end
