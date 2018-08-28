# JSONAPI-Record

[![Gem](https://img.shields.io/gem/v/jsonapi-record.svg?style=flat)](http://rubygems.org/gems/jsonapi-record)
[![CircleCI](https://img.shields.io/circleci/project/github/InspireNL/jsonapi-record.svg)](https://circleci.com/gh/InspireNL/jsonapi-record)

Client framework for interacting JSON:API Spec compliant APIs in Ruby.

Links:

  - [API Docs](https://www.rubydoc.info/gems/jsonapi-record)
  - [Contributing](https://github.com/InspireNL/jsonapi-record/blob/master/CONTRIBUTING.md)
  - [Code of Conduct](https://github.com/InspireNL/jsonapi-record/blob/master/CODE_OF_CONDUCT.md)

## Requirements

1. [Ruby 2.5.0](https://www.ruby-lang.org)

## Installation

To install, run:

```
gem install jsonapi-record
```

Or add the following to your Gemfile:

```
gem "jsonapi-record"
```

## Usage

Defining resources:

```ruby
class Base < JSONAPI::Record::Base
  # Sets the base_uri for your API
  base_uri "https://api.example.com"

  # Sets the default headers for your API requests
  default_headers(authorization: "Bearer Token")
end

class User < Base
  # Define JSON:API resource type
  type "users"
end
```

Defining resource attributes:

```ruby
class User < Base
  type "users"

  attribute :email, JSONAPI::Types::String
  attribute :name, JSONAPI::Types::String
  attribute :age, JSONAPI::Types::String

  def self.creatable_attribute_names
    super - [:age]
  end

  def self.updatable_attribute_names
    super - [:name]
  end
end

user = User.new(email: "user@example.com", name: "User", age: 28)
user.resource_attributes # => { email: "user@example.com", name: "User", age: 28 }
user.creatable_attributes # => { email: "user@example.com", name: "User" }
user.updatable_attributes # => { email: "user@example.com", age: 28 }
```

Defining relationships:

```ruby
class User < JSONAPI::Record::Base
  type "users"

  relationship_to_one :profile, class_name: "Profile"
  relationship_to_many :posts, class_name: "Post"
end

user = User.new(id: "1", profile: Profile.new(id: "1"))
user.profile.class # Profile
user.posts # => []
user.fetch_profile # Performs get request to https://api.example.com/users/1/profile
user.fetch_posts # Performs get request to https://api.example.com/users/1/posts
```

Querying resources:

```ruby
user = User.find("1") # Performs get request to https://api.example.com/users/1
user = User.find("1", include: "posts") # Performs get request to https://api.example.com/users/1?include="posts"
user = User.find!("1") # Same as `find` but raises an exception if resource not found
users = User.all # Performs get request to https://api.example.com/users
users = User.all(include: "posts") # Performs get request to https://api.example.com/users?include="posts"
```

Creating resources:

```ruby
user = User.new(email: "new@example.com")
created_user = User.create(user) # Performs a post request to https://api.example.com/users
created_user.persisted? # => true
```

```ruby
create_user = User.create_with(email: "new@example.com")
create_user.persisted? => true
```

Updating resources:

```ruby
user = User.find("1")
user.persisted? # => true
updated_user = User.update(user.new(email: "changed@example.com")) # Performs a patch request to https://api.example.com/users/1
```

Saving resources:

```ruby
user = User.find("1")
user.persisted? => # true
updated_user = User.save(user) # Performs a patch request to https://api.example.com/users/1

user = User.new
user.persisted? => # false
created_user = User.save(user) # Performs a post request to https://api.example.com/users
created_user.persisted? => true
```

Deleting resources:

```ruby
user = User.find("1")
user.persisted? # => true
deleted_user = User.destroy(user) # Performs a delete request to https://api.example.com/users/1
deleted_user.persisted # => false
```

## Tests

To test, run:

```
bundle exec rspec spec/
```

## Versioning

Read [Semantic Versioning](https://semver.org) for details. Briefly, it means:

- Major (X.y.z) - Incremented for any backwards incompatible public API changes.
- Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
- Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.

## License

Copyright 2018 [Inspire Innovation BV](https://inspire.nl).
Read [LICENSE](LICENSE.md) for details.
