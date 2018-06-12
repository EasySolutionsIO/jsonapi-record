# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONAPI::Resource::Attributes do
  let(:post) { Post.new(title: "Post1", body: "Lorem Ipsum") }

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

  describe ".creatable_attribute_names" do
    it "returns the resource attribute names with creatable option true" do
      expect(Post.creatable_attribute_names).to contain_exactly(:title)
    end
  end

  describe ".updatable_attribute_names" do
    it "returns the resource attribute names with updatable option true" do
      expect(Post.updatable_attribute_names).to contain_exactly(:body)
    end
  end

  describe "#resource_attribute" do
    it "returns a hash with the defined resource attributes" do
      expect(post.resource_attributes).to include(:title, :body)
    end
  end

  describe "#creatable_attribute" do
    it "returns a hash with the defined creatable attributes" do
      expect(post.creatable_attributes).to include(:title)
    end
  end

  describe "#updatable_attribute" do
    it "returns a hash with the defined updatable attributes" do
      expect(post.updatable_attributes).to include(:body)
    end
  end
end
