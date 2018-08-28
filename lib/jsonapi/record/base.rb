# frozen_string_literal: true

module JSONAPI
  module Record
    class Base < Metal
      include Queryable
      include Destroyable
      include Creatable
      include Updatable
      include Persistable
    end
  end
end
