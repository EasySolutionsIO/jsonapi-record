# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Record::Destroyable do
  let(:user_relationships) { { profile: { data: { id: "1", type: "profiles" } } } }
  let(:user) { User.new(id: "1", email: "user@example.com", relationships: user_relationships) }

  describe ".destroy" do
    let(:deleted_user) { User.destroy(user.new(persisted: true)) }

    before do
      stub_request(:delete, User.individual_uri(user.id)).to_return(status: status, body: body.to_json)
    end

    context "when response is a document with no content" do
      let(:status) { 204 }
      let(:body) { nil }

      it "returns a non persited record" do
        expect(deleted_user.persisted?).to be false
      end
    end

    context "when response is a failure document" do
      let(:status) { 422 }
      let(:body) { { errors: [{ title: "Example error." }] } }

      it "returns a persited record with response errors" do
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

    it "raises an exception when deleted record contains errors" do
      expect { User.destroy!(user) }.to raise_error JSONAPI::Client::UnprocessableEntity
    end
  end
end
