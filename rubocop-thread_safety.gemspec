# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop/thread_safety/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop-thread_safety'
  spec.version       = RuboCop::ThreadSafety::VERSION
  spec.authors       = ['Michael Gee']
  spec.email         = ['michaelpgee@gmail.com']

  spec.summary       = 'Thread-safety checks via static analysis'
  spec.description   = <<-DESCRIPTION
    Thread-safety checks via static analysis.
    A plugin for the RuboCop code style enforcing & linting tool.
  DESCRIPTION
  spec.homepage = 'https://github.com/rubocop/rubocop-thread_safety'
  spec.licenses = ['MIT']

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git/ .github/ gemfiles/ Appraisals Gemfile])
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_runtime_dependency 'rubocop', '>= 0.92.0'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'bundler', '>= 1.10', '< 3'
  spec.add_development_dependency 'pry' unless ENV['CI']
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'yard'
end
