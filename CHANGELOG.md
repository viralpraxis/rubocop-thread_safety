# Change log

## master (unreleased)

* [#43](https://github.com/rubocop/rubocop-thread_safety/pull/43): Make detection of ActiveSupport's `class_attribute` configurable. ([@viralpraxis][])
* [#42](https://github.com/rubocop/rubocop-thread_safety/pull/42): Fix some `InstanceVariableInClassMethod` cop false positive offenses. ([@viralpraxis][])
* [#41](https://github.com/rubocop/rubocop-thread_safety/pull/41): Drop support for MRI older than 2.7. ([@viralpraxis][])
* [#38](https://github.com/rubocop/rubocop-thread_safety/pull/38): Fix `NewThread` cop detection is case of `Thread.start`, `Thread.fork`, or `Thread.new` with arguments. ([@viralpraxis][])
* [#36](https://github.com/rubocop/rubocop-thread_safety/pull/36): Add new `DirChdir` cop to detect `Dir.chdir` calls. ([@viralpraxis][])
