# frozen_string_literal: true

module RuboCop
  module Cop
    module ThreadSafety
      # Avoid using `Dir.chdir` due to its process-wide effect.
      #
      # @example
      #   # bad
      #   Dir.chdir("/var/run")
      class DirChdir < Base
        MSG = 'Avoid using `Dir.chdir` due to its process-wide effect.'
        RESTRICT_ON_SEND = %i[chdir].freeze

        def on_send(node)
          return unless node.receiver&.source == 'Dir'

          add_offense(node)
        end
      end
    end
  end
end
