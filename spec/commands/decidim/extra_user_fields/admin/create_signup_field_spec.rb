# frozen_string_literal: true

require "spec_helper"

module Decidim
  module ExtraUserFields
    module Admin
      describe CreateSignupField do
        let(:organization) { create(:organization) }
        let(:user) { create :user, :admin, :confirmed, organization: organization }

        let(:manifest) { "text" }
        let(:title) { { "en" => "Title" } }
        let(:description) { { "en" => "Description" } }
        let(:mandatory) { true }
        let(:masked) { true }
        let(:options) { [
          { label: { "en" => "Option 1" }, value: "option_1" },
          { label: { "en" => "Option 2" }, value: "option_2" },
        ] }

        # rubocop:enable Style/TrailingCommaInHashLiteral

        let(:model) do
          SignupField.new(
            organization: organization,
            manifest: manifest,
            title: title,
            description: description,
            mandatory: mandatory,
            masked: masked,
            options: options
          )
        end
        let(:command) { described_class.new(model) }

        describe "call" do
          context "when the model is not valid" do
            before do
              allow(model).to receive(:invalid?).and_return(true)
            end

            it "broadcasts invalid" do
              expect { command.call }.to broadcast(:invalid)
            end

            it "doesn't update the registration fields" do
              expect do
                command.call
                organization.reload
              end.not_to change(Decidim::SignupField, :count)
            end
          end

          context "when the model is valid" do
            it "broadcasts ok" do
              expect { command.call }.to broadcast(:ok)
            end

            it "updates the organization registration fields" do
              expect do
                command.call
              end.to change(Decidim::SignupField, :count).by(1)
            end
          end
        end
      end
    end
  end
end
