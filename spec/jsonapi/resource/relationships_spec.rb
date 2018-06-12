# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Resource::Relationships do
  let(:user) { User.new(id: "1", email: "user@example.com") }

  describe ".relationship_to_one" do
    it "defines a relationship attribute" do
      expect(user).to respond_to :profile
    end

    it "defines a fetch relationship method" do
      expect(user).to respond_to :fetch_profile
    end
  end

  describe ".relationship_to_many" do
    it "defines a relationship attribute" do
      expect(user).to respond_to :posts
    end

    it "defines a fetch relationship method" do
      expect(user).to respond_to :fetch_posts
    end
  end

  describe "#fetch_related_collection" do
    let(:post) { Post.new(id: "1") }
    let(:posts) { user.fetch_posts }
    let!(:get_request_stub) do
      stub_request(:get, User.related_resource_uri(user.id, "posts"))
        .to_return(status: 200, body: { data: [post.data] }.to_json)
    end

    it "generates a get request to fetch a related collection" do
      expect(posts).to be_an Array
      expect(posts.first.id).to eq post.id
    end
  end

  describe "#fetch_related_resource" do
    let(:profile) { Profile.new(id: "1") }
    let(:fetched_profile) { user.fetch_profile }
    let!(:get_request_stub) do
      stub_request(:get, User.related_resource_uri(user.id, "profile"))
        .to_return(status: 200, body: profile.request_payload.to_json)
    end

    it "generates a get request to fetch fetches a related resource" do
      expect(fetched_profile.id).to eq profile.id
    end
  end
end
