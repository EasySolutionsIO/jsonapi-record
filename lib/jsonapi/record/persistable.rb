# frozen_string_literal: true

module JSONAPI
  module Record
    module Persistable
      def self.extended(base)
        base.include(Creatable)
        base.include(Updatable)
        base.extend(Destroyable)
      end

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
  end
end
