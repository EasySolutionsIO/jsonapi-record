# frozen_string_literal: true

class BlogPost < Post
  type "blog_posts"

  attribute :blog_name, JSONAPI::Types::String
end
