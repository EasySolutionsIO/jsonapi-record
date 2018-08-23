# frozen_string_literal: true

module JSONAPI
  module Resource
    module Updatable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def update(resource)
          response_document =
            JSONAPI::Client.update(
              individual_uri(resource.id), default_headers, resource.payload_attributes_for_update
            )

          case response_document
          when JSONAPI::Types::Success, JSONAPI::Types::Failure
            resource.new(parse(response_document))
          when JSONAPI::Types::Document
            resource.new(persisted: true)
          end
        end

        def update!(resource)
          raise_exception_when_errors { update(resource) }
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
