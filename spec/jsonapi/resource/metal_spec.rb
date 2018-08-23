# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Resource::Metal do
  let(:id) { SecureRandom.uuid }
  let(:user_relationships) { { profile: { data: { id: SecureRandom.uuid, type: "profiles" } } } }
  let(:user) { User.new(id: id, email: "user@example.com", relationships: user_relationships) }
  let(:post) { Post.new(title: "Post1", body: "Lorem Ipsum") }
  let(:type) { User.type }
  let(:base_uri) { User.base_uri }
  let(:relationship_name) { "posts" }
  let(:collection_uri) { "#{base_uri}/#{type}" }
  let(:individual_uri) { "#{base_uri}/#{type}/#{id}" }
  let(:related_resource_uri) { "#{base_uri}/#{type}/#{id}/#{relationship_name}" }

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

  describe ".collection_uri" do
    it "returns collection_uri" do
      expect(User.collection_uri).to eq collection_uri
    end
  end

  describe ".individual_uri" do
    it "returns individual_uri" do
      expect(User.individual_uri(id)).to eq individual_uri
    end
  end

  describe ".related_resource_uri" do
    it "returns related_resource_uri" do
      expect(User.related_resource_uri(id, "posts")).to eq related_resource_uri
    end
  end

  describe ".resource_attribute_names" do
    subject { dummy_class.resource_attribute_names }

    context "for Post" do
      let(:dummy_class) { Post }

      it { is_expected.to contain_exactly(:title, :body) }
    end

    context "for BlogPost" do
      let(:dummy_class) { BlogPost }

      it { is_expected.to contain_exactly(:title, :body, :blog_name) }
    end
  end


  describe "#colletion_uri" do
    it "returns collection_uri" do
      expect(user.collection_uri).to eq collection_uri
    end
  end

  describe "#individual_uri" do
    it "returns individual_uri" do
      expect(user.individual_uri).to eq individual_uri
    end
  end

  describe "#related_resource_uri" do
    it "returns related_resource_uri" do
      expect(user.related_resource_uri("posts")).to eq related_resource_uri
    end
  end

  describe "#resource_attribute" do
    it "returns a hash with the defined resource attributes" do
      expect(post.resource_attributes).to include(:title, :body)
    end
  end

  describe "#to_payload" do
    let(:payload) do
      {
        data: {
          id: user.id,
          type: user.class.type,
          attributes: { email: user.email },
          relationships: user_relationships
        }
      }
    end

    it "returns a hash that represents to payload to send to the server" do
      expect(user.to_payload).to eq payload
    end

    context "when relationships dont have data" do
      let(:payload) do
        {
          data: {
            id: user.id,
            type: user.class.type,
            attributes: { email: user.email }
          }
        }
      end
      let(:user_relationships) { { profile: {} } }

      it "returns a hash without the relationships key" do
        expect(user.to_payload).to eq payload
      end
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
        .to_return(status: 200, body: profile.to_payload.to_json)
    end

    it "generates a get request to fetch fetches a related resource" do
      expect(fetched_profile.id).to eq profile.id
    end
  end
end
