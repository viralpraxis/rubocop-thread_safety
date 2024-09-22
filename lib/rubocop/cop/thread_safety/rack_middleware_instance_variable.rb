# frozen_string_literal: true

module RuboCop
  module Cop
    module ThreadSafety
      # Avoid instance variables in Rack middleware.
      class RackMiddlewareInstanceVariable < Base
        MSG = 'Avoid instance variables in rack middleware.'

        # @!method rack_middleware_application_variable(node)
        def_node_search :rack_middleware_application_variable, <<~MATCHER
          (class
            (const nil _)
            nil
          )
        MATCHER

        # @!method rack_middleware_like_class?(node)
        def_node_matcher :rack_middleware_like_class?, <<~MATCHER
          (class (const nil? _) nil? (begin <(def :initialize (args (arg _)) ...) (def :call ...)>))
        MATCHER

        # @!method constructor_method(node)
        def_node_search :constructor_method, <<~MATCHER
          (def :initialize (args (arg $_)) `(ivasgn $_ (lvar $_)))
        MATCHER

        def on_class(node)
          return unless rack_middleware_like_class?(node)
          return unless (application_variable = extract_application_variable_from_class_node(node))

          node.each_node(:def) do |method_definition_node|
            method_definition_node.each_node(*%i[ivar ivasgn]) do |ivar_node|
              assignable, = ivar_node.to_a
              next if assignable == application_variable

              add_offense ivar_node
            end
          end
        end

        private

        def extract_application_variable_from_class_node(class_node)
          require 'pry'

          class_node
            .each_node(:def)
            .find { |node| node.method?(:initialize) && node.arguments.size == 1 }
            .then { |node| constructor_method(node) }
            .then { |variables| variables.first[1] if variables.first }
        end
      end
    end
  end
end
