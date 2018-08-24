# frozen_string_literal: true

module JSONAPI
  module Record
    module Updatable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # @param record [JSONAPI::Record::Base]
        # @return [JSONAPI::Record::Base]
        def update(record)
          response_document =
            JSONAPI::Client.update(
              individual_uri(record.id), default_headers, record.payload_attributes_for_update
            )

          case response_document
          when JSONAPI::Types::Success, JSONAPI::Types::Failure
            record.new(parse(response_document))
          when JSONAPI::Types::Document
            record.new(persisted: true)
          end
        end

        # @param record [JSONAPI::Record::Base]
        # @raise [JSONAPI::Client::UnprocessableEntity] if update fails.
        # @return [JSONAPI::Record::Base]
        def update!(record)
          raise_exception_when_errors { update(record) }
        end

        # Allows to override the attributes for updating a resource.
        # @return [Array<Symbol>]
        def updatable_attribute_names
          resource_attribute_names
        end
      end

      # Returns the attributes for updating a resource.
      # @return [Hash]
      def updatable_attributes
        attributes.slice(*self.class.updatable_attribute_names)
      end

      # Returns the attributes for the payload for patch request.
      # @return [Hash] if there are updatable attributes.
      # @return [nil] if there are no updatable attributes.
      def payload_attributes_for_update
        updatable_attributes if updatable_attributes.any?
      end
    end
  end
end
