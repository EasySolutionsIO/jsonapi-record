# frozen_string_literal: true

class Post < Base
  type "posts"

  attribute :title, JSONAPI::Types::String
  attribute :body, JSONAPI::Types::String

  def self.creatable_attribute_names
    super - [:body]
  end

  def self.updatable_attribute_names
    super - [:title]
  end
end
