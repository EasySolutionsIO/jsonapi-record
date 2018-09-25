# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Record::Queryable do
  let(:user) { User.new(id: "1", email: "user@example.com", persisted: true) }

  describe ".all" do
    subject(:fetched_users) { User.all }

    before do
      stub_request(:get, User.collection_uri)
        .to_return(status: 200, body: { data: [user.data] }.to_json)
    end

    it { is_expected.to be_an(Array) }

    it "fetches all users" do
      expect(fetched_users).to include(user)
    end
  end

  describe ".find!" do
    subject(:fetched_user) { User.find!(user.id) }

    context "when response status is 200" do
      before do
        stub_request(:get, User.individual_uri(user.id))
          .to_return(status: 200, body: user.to_payload.to_json)
      end

      it "fetches a specific user" do
        expect(fetched_user).to eq(user)
      end
    end

    context "when response status is 404" do
      before { stub_request(:get, User.individual_uri(user.id)).to_return(status: 404) }

      it "raises a JSONAPI::Client::NotFound error" do
        expect { fetched_user }.to raise_error JSONAPI::Client::NotFound
      end
    end
  end

  describe ".find" do
    subject(:fetched_user) { User.find(user.id) }

    context "when response status is 404" do
      before { stub_request(:get, User.individual_uri(user.id)).to_return(status: 404) }

      it { is_expected.to be_nil }
    end
  end
end
