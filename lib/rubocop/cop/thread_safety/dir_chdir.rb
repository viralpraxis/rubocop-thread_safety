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

        # @!method dir_chdir?(node)
        def_node_matcher :dir_chdir?, <<~MATCHER
          (send (const {nil? cbase} :Dir) :chdir ...)
        MATCHER

        def on_send(node)
          dir_chdir?(node) { add_offense(node) }
        end
      end
    end
  end
end
