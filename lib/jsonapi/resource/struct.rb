# frozen_string_literal: true

module JSONAPI
  module Resource
    class Struct < Dry::Struct
      # Convert string keys to symbols
      transform_keys(&:to_sym)

      # Resolve default types on nil
      transform_types do |type|
        if type.default?
          type.constructor do |value|
            value.nil? ? Dry::Types::Undefined : value
          end
        else
          # Make all types omittable
          type.meta(omittable: true)
        end
      end
    end
  end
end
