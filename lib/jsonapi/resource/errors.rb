# frozen_string_literal: true

module JSONAPI
  module Resource
    module Errors
      def errors
        hash_with_defaults = Hash.new { |hash, key| hash[key] = [] }
        response_errors_or_default.each_with_object(hash_with_defaults).each do |response_error, errors|
          if response_error.source&.attribute # rubocop:disable Style/IfUnlessModifier
            errors[response_error.source.attribute] << response_error.title
          end
        end
      end

      private

      def response_errors_or_default
        response_errors || []
      end
    end
  end
end
