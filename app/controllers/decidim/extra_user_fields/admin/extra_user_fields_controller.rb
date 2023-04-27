# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      class ExtraUserFieldsController < Admin::ApplicationController
        layout "decidim/admin/settings"

        helper_method :signup_fields, :new_signup_field_path, :signup_field_name, :signup_field_manifest

        def index
          enforce_permission_to :read, :extra_user_fields

          @form = form(ExtraUserFieldsForm).from_model(current_organization)
        end

        def update
          enforce_permission_to :update, :extra_user_fields

          @form = form(ExtraUserFieldsForm).from_params(
            params,
            current_organization: current_organization
          )

          UpdateExtraUserFields.call(@form) do
            on(:ok) do
              flash[:notice] = t(".success")
              render action: "index"
            end

            on(:invalid) do
              flash.now[:alert] = t(".failure")
              render action: "index"
            end
          end
        end

        def export_users
          enforce_permission_to :read, :officialization

          ExportUsers.call(params[:format], current_user) do
            on(:ok) do |export_data|
              send_data export_data.read, type: "text/#{export_data.extension}", filename: export_data.filename("participants")
            end
          end
        end

        private

        def signup_fields(status)
          status == "active" ? active_fields : inactive_fields
        end

        def active_fields
          @active_fields ||= Decidim::SignupField.actives_ordered(organization: current_organization)
        end

        def inactive_fields
          @inactive_fields ||= Decidim::SignupField.inactives(current_organization)
        end

        def signup_field_name(signup_field)
          signup_field_current_locale?(signup_field)
        end

        def signup_field_manifest(signup_field)
          translated_field(signup_field.manifest)
        end

        def translated_field(field)
          field_translations = {
            "text" => "Short Text",
            "textarea" => "Long Text",
            "date" => "Date",
            "select" => "Dropdown",
            "checkbox" => "Checkbox",
            "radio" => "Radio Button"
          }

          field_translations[field]
        end

        def signup_field_current_locale?(signup_field)
          signup_field.title[current_locale].presence || "#{signup_field.title[signup_field.title.keys.first]} (#{signup_field.title.keys.first})"
        end
      end
    end
  end
end
