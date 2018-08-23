# frozen_string_literal: true

module JSONAPI
  module Record
    module Updatable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
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

        def update!(record)
          raise_exception_when_errors { update(record) }
        end

        def updatable_attribute_names
          resource_attribute_names
        end
      end

      def updatable_attributes
        attributes.slice(*self.class.updatable_attribute_names)
      end

      def payload_attributes_for_update
        updatable_attributes if updatable_attributes.any?
      end
    end
  end
end
