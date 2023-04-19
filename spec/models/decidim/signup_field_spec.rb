# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe SignupField do
    subject { build(:signup_field, organization: organization, title: title, mandatory: mandatory, masked: masked) }

    let(:mandatory) { true }
    let(:masked) { true }
    let(:title) { { "en" => "Title" } }
    let(:description) { { "en" => "Description" } }
    let(:organization) { create(:organization) }

    it { is_expected.to be_valid }

    describe "#title" do
      context "when title already exists" do
        let!(:already_existing) { create(:signup_field, organization: organization, title: title) }

        it { is_expected.to be_invalid }
      end
    end

    describe "#actives_ordered" do
      let!(:first_signup_field) { create(:signup_field, organization: organization, weight: 0) }
      let!(:third_signup_field) { create(:signup_field, organization: organization, weight: 2) }
      let!(:second_signup_field) { create(:signup_field, organization: organization, weight: 1) }

      it "returns signup field ordered by weight asc" do
        signup_fields = Decidim::SignupField.actives_ordered(organization: organization)
        expect(signup_fields.first).to eq(first_signup_field)
        expect(signup_fields.second).to eq(second_signup_field)
        expect(signup_fields.third).to eq(third_signup_field)
      end
    end

    describe "#actives" do
      let(:actives) { create_list(:signup_field, 5, organization: organization) }
      let(:inactives) { create_list(:signup_field, 5, :inactive, organization: organization) }

      it "returns published signup fields" do
        expect(SignupField.actives(organization)).to match(actives)
      end
    end

    describe "#inactives" do
      let(:actives) { create_list(:signup_field, 5, organization: organization) }
      let(:inactives) { create_list(:signup_field, 5, :inactive, organization: organization) }

      it "returns unpublished signup fields" do
        expect(SignupField.inactives(organization)).to match(inactives)
      end
    end
  end
end
