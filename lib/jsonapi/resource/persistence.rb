# frozen_string_literal: true

module JSONAPI
  module Resource
    module Persistence
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def save(resource)
          resource.persisted? ? update(resource) : create(resource)
        end

        def save!(resource)
          raise_exception_when_errors { save(resource) }
        end

        def create(resource)
          response_document =
            JSONAPI::Client.create(collection_uri, default_headers, resource.request_payload) 

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

        def update(resource)
          response_document =
            JSONAPI::Client.update(individual_uri(resource.id), default_headers, resource.request_payload)

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

        def destroy(resource)
          response_document = JSONAPI::Client.delete(individual_uri(resource.id), default_headers)

          case response_document
          when JSONAPI::Types::Failure
            resource.new(parse(response_document))
          when JSONAPI::Types::Info
            resource.new(persisted: false, **parse(response_document))
          when JSONAPI::Types::Document
            resource.new(persisted: false)
          end
        end

        def destroy!(resource)
          raise_exception_when_errors { destroy(resource) }
        end

        private

        def raise_exception_when_errors(&block)
          yield(block).tap do |resource|
            if (errors = resource.response_errors)
              raise JSONAPI::Client::UnprocessableEntity, errors
            end
          end
        end
      end

      def persisted?
        persisted
      end

      def to_relationship
        { data: identifier }
      end

      def identifier
        { id: id, type: self.class.type }
      end

      def request_payload
        { data: data }
      end

      def data
        identifier
          .merge(attributes: attributes_for_request)
          .merge(relationships: relationships_for_request)
          .compact
      end

      private

      def attributes_for_request
        (persisted? ? updatable_attributes : creatable_attributes)
          .yield_self { |results| results if results.any? }
      end

      def relationships_for_request
        relationships_or_default
          .transform_values { |relationship| relationship.to_hash.slice(:data) }
          .compact
          .yield_self { |results| results if results.any? }
      end

      def relationships_or_default
        relationships || {}
      end
    end
  end
end
