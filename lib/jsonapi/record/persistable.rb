# frozen_string_literal: true

module JSONAPI
  module Record
    module Persistable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Calls `.create` if the record is persisted, otherwise calls `.update`.
        # @param record [JSONAPI::Record::Base]
        # @return [JSONAPI::Record::Base]
        def save(record)
          record.persisted? ? update(record) : create(record)
        end

        # @param record [JSONAPI::Record::Base]
        # @raise [JSONAPI::Client::UnprocessableEntity] if save fails.
        # @return [JSONAPI::Record::Base]
        def save!(record)
          raise_exception_when_errors { save(record) }
        end
      end

      # Override #payload_attributes
      def payload_attributes
        persisted? ? payload_attributes_for_update : payload_attributes_for_create
      end
    end
  end
end
