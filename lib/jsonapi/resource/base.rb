# frozen_string_literal: true

module JSONAPI
  module Resource
    class Base < Metal
      extend Queryable
      extend Persistable
    end
  end
end
