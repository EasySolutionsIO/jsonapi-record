# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Record::Parser do
  subject { described_class.parse(document) }

  describe ".parse" do
    context "when document is a JSONAPI::Types::Info" do
      let(:document) { JSONAPI::Types::Info.new(meta: { author: "John Doe" }) }

      it { is_expected.to eq(top_level_meta: { author: "John Doe" }) }
    end

    context "when document is a JSONAPI::Types::Success" do
      let(:included_comment1) { { id: "1", type: "comments", attributes: { body: "Hi!" } } }
      let(:included_comment2) { { id: "2", type: "comments", attributes: { body: "Hello!" } } }
      let(:included) { [included_comment1, included_comment2] }
      let(:document) { JSONAPI::Types::Success.new(data: data, included: included) }
      let(:user1) { { id: "1", type: "users", relationships: relationships } }
      let(:comment1) { included_comment1.slice(:id, :type) }
      let(:comment2) { included_comment2.slice(:id, :type) }
      let(:comments_relationship) { { data: [comment1, comment2] } }
      let(:relationships) { { comments: comments_relationship } }
      let(:parsed_comment1) { { id: "1", body: "Hi!", persisted: true } }
      let(:parsed_comment2) { { id: "2", body: "Hello!", persisted: true } }
      let(:parsed_user1) do
        {
          id: "1",
          comments: [parsed_comment1, parsed_comment2],
          relationships: {
            comments: JSONAPI::Types::Relationship.new(data: [comment1, comment2])
          },
          persisted: true
        }
      end

      context "when document is a resource" do
        let(:data) { user1 }

        it { is_expected.to eq(parsed_user1) }
      end

      context "when document data is an array" do
        let(:parsed_user2) { { id: "2", persisted: true } }
        let(:user2) { { id: "2", type: "users" } }
        let(:data) { [user1, user2] }

        it { is_expected.to eq([parsed_user1, parsed_user2]) }
      end
    end

    context "when document is a JSONAPI::Types::Failure" do
      let(:error_attributes) { { title: "Error" } }
      let(:error) { JSONAPI::Types::Error.new(error_attributes) }
      let(:document) { JSONAPI::Types::Failure.new(errors: [error_attributes]) }

      it { is_expected.to eq(response_errors: [error]) }
    end
  end
end
