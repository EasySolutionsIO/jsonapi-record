# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Resource::Persistence do
  let(:user_relationships) { { profile: { data: { id: "1", type: "profiles" } } } }
  let(:user) { User.new(id: "1", email: "user@example.com", relationships: user_relationships) }

  describe ".create" do
    let(:created_user) { User.save(user) }

    before do
      stub_request(:post, User.collection_uri).to_return(status: status, body: body.to_json)
    end

    context "when response is a success document" do
      let(:status) { 201 }
      let(:body) { user.request_payload }

      it "returns a persisted resource" do
        expect(created_user.persisted?).to be true
      end
    end

    context "when response is a failure document" do
      let(:status) { 422 }
      let(:body) { { errors: [{ title: "Example error." }] } }

      it "returns a non persisted resource with response errors" do
        expect(created_user.persisted?).to be false
        expect(created_user.response_errors.any?).to be true
      end
    end
  end

  describe ".update" do
    let(:updated_user) { User.save(user.new(email: "change@example.com", persisted: true)) }

    before do
      stub_request(:patch, User.individual_uri(user.id)).to_return(status: status, body: body.to_json)
    end

    context "when response is a success document" do
      let(:status) { 200 }
      let(:body) { user.request_payload }

      it "returns a persisted resource" do
        expect(updated_user.persisted?).to be true
      end
    end

    context "when response is a failure document" do
      let(:status) { 422 }
      let(:body) { { errors: [{ title: "Example error." }] } }

      it "returns a persisted resource with response errors" do
        expect(updated_user.persisted?).to be true
        expect(updated_user.response_errors.any?).to be true
      end
    end
  end

  describe ".create!" do
    let(:errors) { { errors: [{ title: "Example error." }] } }

    before do
      stub_request(:post, User.collection_uri).to_return(status: 422, body: errors.to_json)
    end

    it "raises an exception when saved resource contains errors" do
      expect { User.create!(user) }.to raise_error JSONAPI::Client::UnprocessableEntity
    end
  end

  describe ".update!" do
    let(:errors) { { errors: [{ title: "Example error." }] } }

    before do
      stub_request(:patch, User.individual_uri(user.id)).to_return(status: 422, body: errors.to_json)
    end

    it "raises an exception when saved resource contains errors" do
      expect { User.update!(user) }.to raise_error JSONAPI::Client::UnprocessableEntity
    end
  end

  describe ".create_with" do
    let(:created_user) { User.create_with(id: "2", email: "user2@example.com") }
    let(:body) { { data: { id: "2", type: "users", attributes: { email: "user2@example.com" } } } }

    before do
      stub_request(:post, User.collection_uri).to_return(status: 201, body: body.to_json)
    end

    it "returns a persisted resource" do
      expect(created_user).to an_instance_of User
      expect(created_user.persisted?).to be true
    end
  end

  describe ".create_with!" do
    let(:errors) { { errors: [{ title: "Example error." }] } }

    before do
      stub_request(:post, User.collection_uri).to_return(status: 422, body: errors.to_json)
    end

    it "raises an exception when created resource contains errors" do
      expect { User.create_with!({}) }.to raise_error JSONAPI::Client::UnprocessableEntity
    end
  end

  describe ".destroy" do
    let(:deleted_user) { User.destroy(user.new(persisted: true)) }

    before do
      stub_request(:delete, User.individual_uri(user.id)).to_return(status: status, body: body.to_json)
    end

    context "when response is a document with no content" do
      let(:status) { 204 }
      let(:body) { nil }

      it "returns a non persited resource" do
        expect(deleted_user.persisted?).to be false
      end
    end

    context "when response is a failure document" do
      let(:status) { 422 }
      let(:body) { { errors: [{ title: "Example error." }] } }

      it "returns a persited resource with response errors" do
        expect(deleted_user.persisted?).to be true
        expect(deleted_user.response_errors.any?).to be true
      end
    end
  end

  describe ".destroy!" do
    let(:errors) { { errors: [{ title: "Example error." }] } }

    before do
      stub_request(:delete, User.individual_uri(user.id)).to_return(status: 422, body: errors.to_json)
    end

    it "raises an exception when deleted resource contains errors" do
      expect { User.destroy!(user) }.to raise_error JSONAPI::Client::UnprocessableEntity
    end
  end

  describe "#request_payload" do
    let(:request_payload) do
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
      expect(user.request_payload).to eq request_payload
    end
  end
end
