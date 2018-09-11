# frozen_string_literal: true

class Post < Base
  type "posts"

  attribute :title, Types::String
  attribute :body, Types::String

  def self.creatable_attribute_names
    super - [:body]
  end

  def self.updatable_attribute_names
    super - [:title]
  end
end
