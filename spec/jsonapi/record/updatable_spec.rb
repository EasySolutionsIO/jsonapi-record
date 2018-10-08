# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Record::Updatable do
  let(:user) { User.new(id: "1", email: "user@example.com") }
  let(:post) { Post.new(title: "Post1", body: "Lorem Ipsum") }

  describe ".update" do
    let(:updated_user) { User.update(user.new(email: "change@example.com", persisted: true)) }

    before do
      stub_request(:patch, User.individual_uri(user.id)).to_return(status: status, body: body.to_json)
    end

    context "when response is a success document" do
      let(:status) { 200 }
      let(:body) { user.to_payload }

      it "returns a persisted record" do
        expect(updated_user.persisted?).to be true
      end
    end

    context "when response is a failure document" do
      let(:status) { 422 }
      let(:body) { { errors: [{ title: "Example error." }] } }

      it "returns a persisted record" do
        expect(updated_user.persisted?).to be(true)
      end

      it "loads errors" do
        expect(updated_user.response_errors.any?).to be(true)
      end
    end
  end

  describe ".update!" do
    let(:errors) { { errors: [{ title: "Example error." }] } }

    before do
      stub_request(:patch, User.individual_uri(user.id)).to_return(status: 422, body: errors.to_json)
    end

    it "raises an exception when saved resource contains errors" do
      expect { User.update!(user) }.to raise_error JSONAPI::SimpleClient::UnprocessableEntity
    end
  end

  describe ".updatable_attribute_names" do
    it "returns the resource attribute names with updatable option true" do
      expect(Post.updatable_attribute_names).to contain_exactly(:body)
    end
  end

  describe "#updatable_attribute" do
    it "returns a hash with the defined updatable attributes" do
      expect(post.updatable_attributes).to include(:body)
    end
  end
end
