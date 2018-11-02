# frozen_string_literal: true

class UserWithScopedUri < Base
  type "users"

  base_uri "https://api.example.com/api/v1/"

  attribute :email, Types::String

  relationship_to_many :posts, class_name: "Post"
  relationship_to_one :profile, class_name: "Profile"
end
