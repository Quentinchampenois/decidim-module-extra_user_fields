# frozen_string_literal: true

require "spec_helper"

module Decidim::ExtraUserFields::Admin
  describe Permissions do
    subject { described_class.new(user, permission_action, context).permissions.allowed? }

    let(:organization) { create :organization }
    let(:context) do
      {
        current_organization: organization
      }
    end
    let(:action) { :read }
    let(:scope) { :admin }

    let(:permission_action) { Decidim::PermissionAction.new(scope: scope, action: action, subject: :extra_user_fields) }

    context "when user is admin" do
      let(:user) { create :user, :admin, organization: organization }

      it { is_expected.to be_truthy }

      context "when scope is not admin" do
        let(:action) { :read }
        let(:scope) { :foo }

        it_behaves_like "permission is not set"
      end
    end

    context "when user is not admin" do
      let(:user) { create :user, organization: organization }

      context "and tries to read extra user fields" do
        let(:action) { :read }
        let(:scope) { :admin }

        it_behaves_like "permission is not set"
      end

      context "and tries to update extra user fields" do
        let(:action) { :update }
        let(:scope) { :admin }

        it_behaves_like "permission is not set"
      end
    end
  end
end
