# frozen_string_literal: true

class Profile < Base
  type "profiles"

  attribute :first_name, JSONAPI::Types::String
  attribute :last_name, JSONAPI::Types::String
end
