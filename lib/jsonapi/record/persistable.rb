# frozen_string_literal: true

module JSONAPI
  module Record
    module Persistable
      def self.extended(base)
        base.include(Creatable)
        base.include(Updatable)
        base.extend(Destroyable)
      end

      def save(record)
        record.persisted? ? update(record) : create(record)
      end

      def save!(record)
        raise_exception_when_errors { save(record) }
      end
    end
  end
end
