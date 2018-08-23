# frozen_string_literal: true

module JSONAPI
  module Resource
    module Creatable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def create(resource)
          response_document =
            JSONAPI::Client.create(
              collection_uri, default_headers, resource.payload_attributes_for_create
            )

          case response_document
          when JSONAPI::Types::Success, JSONAPI::Types::Failure
            resource.new(parse(response_document))
          when JSONAPI::Types::Document
            resource.new(persisted: true)
          end
        end

        def create!(resource)
          raise_exception_when_errors { create(resource) }
        end

        def create_with(attributes)
          create(new(attributes))
        end

        def create_with!(attributes)
          create!(new(attributes))
        end

        def creatable_attribute_names
          resource_attribute_names
        end
      end

      def creatable_attributes
        attributes.slice(*self.class.creatable_attribute_names)
      end

      def payload_attributes_for_create
        creatable_attributes if creatable_attributes.any?
      end
    end
  end
end
