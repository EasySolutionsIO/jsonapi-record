# frozen_string_literal: true

module JSONAPI
  module Resource
    module URIs
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def base_uri
          raise NotImplementedError, "Abstract Method"
        end

        def collection_uri
          URI.join(base_uri, collection_path).to_s
        end

        def individual_uri(id)
          URI.join(base_uri, individual_path(id)).to_s
        end

        def related_resource_uri(id, relationship_name)
          URI.join(base_uri, related_resource_path(id, relationship_name)).to_s
        end

        def collection_path
          "/#{type}"
        end

        def individual_path(id)
          "#{collection_path}/#{id}"
        end

        def related_resource_path(id, relationship_name)
          "#{individual_path(id)}/#{relationship_name}"
        end
      end

      def collection_uri
        self.class.collection_uri
      end

      def individual_uri
        self.class.individual_uri(id)
      end

      def related_resource_uri(relationship_name)
        self.class.related_resource_uri(id, relationship_name)
      end
    end
  end
end
