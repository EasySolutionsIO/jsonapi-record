# frozen_string_literal: true

module JSONAPI
  module Record
    module Creatable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # @param record [JSONAPI::Record::Base]
        # @return [JSONAPI::Record::Base]
        def create(record)
          response_document =
            JSONAPI::Client.create(
              collection_uri, default_headers, record.to_payload
            )

          case response_document
          when Types::Success, Types::Failure
            record.new(parse(response_document))
          when Types::Document
            record.new(persisted: true)
          end
        end

        # @param record [JSONAPI::Record::Base]
        # @raise [JSONAPI::Client::UnprocessableEntity] if create fails.
        # @return [JSONAPI::Record::Base]
        def create!(record)
          raise_exception_when_errors { create(record) }
        end

        # @param attributes [Hash]
        # @return [JSONAPI::Record::Base]
        def create_with(attributes)
          create(new(attributes))
        end

        # @param attributes [Hash]
        # @raise [JSONAPI::Client::UnprocessableEntity] if create fails.
        # @return [JSONAPI::Record::Base]
        def create_with!(attributes)
          create!(new(attributes))
        end

        # Allows to override the attributes for creating a resource.
        # @return [Array<Symbol>]
        def creatable_attribute_names
          resource_attribute_names
        end
      end

      # Returns the attributes for creating a resource.
      # @return [Hash]
      def creatable_attributes
        attributes.slice(*self.class.creatable_attribute_names)
      end

      # Override #payload_attributes
      def payload_attributes
        payload_attributes_for_create
      end

      # Returns the attributes for the payload for post request.
      # @return [Hash] if there are creatable attributes.
      # @return [nil] if there are no creatable attributes.
      def payload_attributes_for_create
        creatable_attributes if creatable_attributes.any?
      end
    end
  end
end
