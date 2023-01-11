# frozen_string_literal: true

require "spec_helper"

describe Decidim::ExtraUserFields::Admin::ExportUsers do
  let(:current_organization) { create(:organization) }
  let(:user) { create :user, :admin, :confirmed, organization: current_organization }
  let(:format) { "CSV" }

  let(:command) do
    described_class.new(format, user, current_organization)
  end

  describe "call" do
    context "when the user tries to export the users" do
      it "broadcasts ok " do
        expect { command.call }.to broadcast(:ok)
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:perform_action!)
          .with(:export_users, current_organization, user)
          .and_call_original

        expect { command.call }.to change(Decidim::ActionLog, :count).by(1)
      end
    end
  end
end
