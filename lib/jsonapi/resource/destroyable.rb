# frozen_string_literal: true

module JSONAPI
  module Resource
    module Destroyable
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
    end
  end
end
