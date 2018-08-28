# frozen_string_literal: true

module JSONAPI
  module Record
    class Base < Metal
      extend Queryable
      extend Persistable
    end
  end
end
