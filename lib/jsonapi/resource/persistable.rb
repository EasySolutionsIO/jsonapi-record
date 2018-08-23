# frozen_string_literal: true

module JSONAPI
  module Resource
    module Persistable
      def self.extended(base)
        base.include(Creatable)
        base.include(Updatable)
        base.extend(Destroyable)
      end

      def save(resource)
        resource.persisted? ? update(resource) : create(resource)
      end

      def save!(resource)
        raise_exception_when_errors { save(resource) }
      end
    end
  end
end
