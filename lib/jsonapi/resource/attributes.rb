# frozen_string_literal: true

module JSONAPI
  module Resource
    module Attributes
      def self.included(base)
        base.extend(ClassMethods)
        base.instance_variable_set(:@attributes_registry, {})
      end

      module ClassMethods
        attr_reader :attributes_registry

        def inherited(subclass)
          subclass.instance_variable_set(:@attributes_registry, **attributes_registry)
          super
        end

        def resource_attribute(name, type, creatable: true, updatable: true)
          @attributes_registry[name] = { creatable: creatable, updatable: updatable }
          attribute name, type # calls Dry::Struct.attribute
        end

        def resource_attribute_names
          attributes_registry.keys
        end

        def creatable_attribute_names
          attributes_registry.select { |_name, options| options[:creatable] }.keys
        end

        def updatable_attribute_names
          attributes_registry.select { |_name, options| options[:updatable] }.keys
        end
      end

      def resource_attributes
        attributes.slice(*self.class.resource_attribute_names)
      end

      def creatable_attributes
        attributes.slice(*self.class.creatable_attribute_names)
      end

      def updatable_attributes
        attributes.slice(*self.class.updatable_attribute_names)
      end
    end
  end
end
