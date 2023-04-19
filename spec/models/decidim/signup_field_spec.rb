# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe SignupField do
    subject { build(:signup_field, organization: organization,title: title, mandatory: mandatory, masked: masked) }

    let(:mandatory) { true }
    let(:masked) { true }
    let(:title) { { "en" => "Title" } }
    let(:organization) { create(:organization) }

    it { is_expected.to be_valid }

    describe "#mandatory" do
      context "when mandatory is true" do
        it "returns true" do
          expect(subject.mandatory).to be_truthy
        end
      end

      context "when mandatory is false" do
        let(:mandatory) { false }

        it "returns false" do
          expect(subject.mandatory).to be_falsey
        end
      end
    end

    describe "#masked" do
      context "when masked is true" do
        it "returns true" do
          expect(subject.masked).to be_truthy
        end
      end

      context "when masked is false" do
        let(:masked) { false }

        it "returns false" do
          expect(subject.masked).to be_falsey
        end
      end
    end

    describe "#title" do
      context "when title already exists" do
        let!(:already_existing) { create(:signup_field, organization:organization, title: title) }

        it { is_expected.to be_invalid }
      end
    end
  end
end
