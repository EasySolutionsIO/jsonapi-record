# frozen_string_literal: true

module JSONAPI
  module Record
    module Destroyable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # @param record [JSONAPI::Record::Base]
        # @return [JSONAPI::Record::Base]
        def destroy(record)
          response_document = JSONAPI::SimpleClient.delete(individual_uri(record.id), default_headers)

          case response_document
          when Types::Failure
            record.new(parse(response_document))
          when Types::Info
            record.new(persisted: false, **parse(response_document))
          when Types::Document
            record.new(persisted: false)
          end
        end

        # @param record [JSONAPI::Record::Base]
        # @raise [JSONAPI::SimpleClient::UnprocessableEntity] if destroy fails.
        # @return [JSONAPI::Record::Base]
        def destroy!(record)
          raise_exception_when_errors { destroy(record) }
        end
      end
    end
  end
end
