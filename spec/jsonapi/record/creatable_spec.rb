# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Record::Creatable do
  let(:user) { User.new(id: "1", email: "user@example.com") }
  let(:post) { Post.new(title: "Post1", body: "Lorem Ipsum") }

  describe ".create" do
    subject(:created_user) { User.create(user) }

    before do
      stub_request(:post, User.collection_uri).to_return(status: status, body: body.to_json)
    end

    context "when response is a success document" do
      let(:status) { 201 }
      let(:body) { user.to_payload }

      it "returns a persisted record" do
        expect(created_user.persisted?).to be(true)
      end
    end

    context "when response is a failure document" do
      let(:status) { 422 }
      let(:body) { { errors: [{ title: "Example error." }] } }

      it "returns a non persisted record" do
        expect(created_user.persisted?).to be(false)
      end

      it "loads errors" do
        expect(created_user.response_errors.any?).to be(true)
      end
    end
  end

  describe ".create!" do
    let(:errors) { { errors: [{ title: "Example error." }] } }

    before do
      stub_request(:post, User.collection_uri).to_return(status: 422, body: errors.to_json)
    end

    it "raises an exception when saved record contains errors" do
      expect { User.create!(user) }.to raise_error JSONAPI::Client::UnprocessableEntity
    end
  end

  describe ".create_with" do
    subject(:created_user) { User.create_with(id: "2", email: "user2@example.com") }

    let(:body) { { data: { id: "2", type: "users", attributes: { email: "user2@example.com" } } } }

    before do
      stub_request(:post, User.collection_uri).to_return(status: 201, body: body.to_json)
    end

    it { is_expected.to be_a(User) }

    it "returns a persisted record" do
      expect(created_user.persisted?).to be true
    end
  end

  describe ".create_with!" do
    let(:errors) { { errors: [{ title: "Example error." }] } }

    before do
      stub_request(:post, User.collection_uri).to_return(status: 422, body: errors.to_json)
    end

    it "raises an exception when created record contains errors" do
      expect { User.create_with!({}) }.to raise_error JSONAPI::Client::UnprocessableEntity
    end
  end

  describe ".creatable_attribute_names" do
    it "returns the record attribute names with creatable option true" do
      expect(Post.creatable_attribute_names).to contain_exactly(:title)
    end
  end

  describe "#creatable_attribute" do
    it "returns a hash with the defined creatable attributes" do
      expect(post.creatable_attributes).to include(:title)
    end
  end
end
