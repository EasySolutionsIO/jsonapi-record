# frozen_string_literal: true

class Profile < Base
  type "profiles"

  attribute :first_name, Types::String
  attribute :last_name, Types::String
end
