# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Resource::URIs do
  let(:id) { SecureRandom.uuid }
  let(:type) { User.type }
  let(:base_uri) { User.base_uri }
  let(:relationship_name) { "posts" }
  let(:collection_uri) { "#{base_uri}/#{type}" }
  let(:individual_uri) { "#{base_uri}/#{type}/#{id}" }
  let(:related_resource_uri) { "#{base_uri}/#{type}/#{id}/#{relationship_name}" }

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

  context "instance methods" do
    let(:user) { User.new(id: id) }

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
  end
end
