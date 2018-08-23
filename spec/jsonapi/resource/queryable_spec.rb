# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Resource::Queryable do
  let(:user) { User.new(id: "1", email: "user@example.com") }

  describe ".all" do
    let(:fetched_users) { User.all }
    let!(:get_request_sub) do
      stub_request(:get, User.collection_uri)
        .to_return(status: 200, body: { data: [user.data] }.to_json)
    end

    it "performs a get request to fetch users" do
      expect(fetched_users).to be_an Array
      expect(fetched_users.first.id).to eq user.id
      expect(fetched_users.first.email).to eq user.email
      expect(fetched_users.first.persisted?).to eq true
    end
  end

  describe ".find!" do
    let(:fetched_user) { User.find!(user.id) }

    context "when response status is 200" do
      let!(:get_request_sub) do
        stub_request(:get, User.individual_uri(user.id))
          .to_return(status: 200, body: user.to_payload.to_json)
      end

      it "performs a get request to fetch a specific user" do
        expect(fetched_user.id).to eq user.id
        expect(fetched_user.email).to eq user.email
        expect(fetched_user.persisted?).to eq true
      end
    end

    context "when response status is 404" do
      let!(:get_request_sub) { stub_request(:get, User.individual_uri(user.id)).to_return(status: 404) }

      it "raises a JSONAPI::Client::NotFound error" do
        expect { fetched_user }.to raise_error JSONAPI::Client::NotFound
      end
    end
  end

  describe ".find" do
    let(:fetched_user) { User.find(user.id) }

    context "when response status is 404" do
      let!(:get_request_sub) { stub_request(:get, User.individual_uri(user.id)).to_return(status: 404) }

      it "returns nil" do
        expect(fetched_user).to be nil
      end
    end
  end
end
