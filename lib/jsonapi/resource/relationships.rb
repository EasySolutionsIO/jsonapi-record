# frozen_string_literal: true

module JSONAPI
  module Resource
    module Relationships
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def relationship_to_one(name, class_name:)
          klass = Object.const_get(class_name)
          define_relationship_attribute(name, Types::Definition(klass))
          define_fetch_relationship_method(name, klass, :fetch_related_resource)
        end

        def relationship_to_many(name, class_name:)
          klass = Object.const_get(class_name)
          define_relationship_attribute(name, JSONAPI::Types::Array.of(klass).default([]))
          define_fetch_relationship_method(name, klass, :fetch_related_collection)
        end

        def define_relationship_attribute(name, type)
          attribute name, type # calls Dry::Struct.attribute
        end

        def define_fetch_relationship_method(name, klass, fetch_method)
          define_method("fetch_#{name}") do |query = {}|
            send(fetch_method, name, klass, query)
          end
        end
      end

      def fetch_related_resource(relationship_name, klass, query = {})
        klass.fetch_resource(related_resource_uri(relationship_name), query)
      end

      def fetch_related_collection(relationship_name, klass, query = {})
        klass.fetch_collection(related_resource_uri(relationship_name), query)
      end
    end
  end
end
