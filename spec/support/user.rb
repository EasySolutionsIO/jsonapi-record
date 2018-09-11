# frozen_string_literal: true

class User < Base
  type "users"

  attribute :email, Types::String

  relationship_to_many :posts, class_name: "Post"
  relationship_to_one :profile, class_name: "Profile"
end
