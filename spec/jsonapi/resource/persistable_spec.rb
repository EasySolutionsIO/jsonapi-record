# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Record::Persistable do
  let(:user) { User.new(id: "1", email: "user@example.com") }
  let(:post) { Post.new(title: "Post1", body: "Lorem Ipsum") }

  describe ".save" do
    context "when record is not persisted" do
      let(:created_user) { User.save(user) }
      let(:status) { 201 }
      let(:body) { user.to_payload }

      before do
        stub_request(:post, User.collection_uri).to_return(status: status, body: body.to_json)
      end

      it "performs a create request and returns a persisted record" do
        expect(created_user.persisted?).to be true
      end
    end

    context "when record is already respisted" do
      let(:updated_user) { User.save(user.new(email: "change@example.com", persisted: true)) }
      let(:status) { 200 }
      let(:body) { user.to_payload }

      before do
        stub_request(:patch, User.individual_uri(user.id)).to_return(status: status, body: body.to_json)
      end

      it "returns a persisted record" do
        expect(updated_user.persisted?).to be true
      end
    end
  end
end
