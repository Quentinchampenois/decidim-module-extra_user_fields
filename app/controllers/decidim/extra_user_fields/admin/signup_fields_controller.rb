# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class SignupFieldsController < Admin::ApplicationController
        layout "decidim/admin/settings"

        def new
          enforce_permission_to :read, :extra_user_fields

          @form = Decidim::ExtraUserFields::Admin::SignupFieldsForm.new
        end

        def create
          enforce_permission_to :create, :extra_user_fields

          @form = Decidim::ExtraUserFields::Admin::SignupFieldsForm.from_params(params)

          CreateSignupField.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("signup_fields.create.success", scope: "decidim.extra_user_fields.admin")
              redirect_to extra_user_fields_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("signup_fields.create.error", scope: "decidim.extra_user_fields.admin")
              render :new
            end
          end
        end

        def edit
          enforce_permission_to :update, :signup_field

          @form = Decidim::ExtraUserFields::Admin::SignupFieldsForm.from_model(signup_field)
        end

        def update
          enforce_permission_to :update, :signup_field

          @form = Decidim::ExtraUserFields::Admin::SignupFieldsForm.from_params(
            params,
            current_organization: current_organization
          )

          UpdateSignupField.call(@form) do
            # TODO: Handle :not_found response
            on(:ok) do
              flash[:notice] = I18n.t("signup_fields.update.success", scope: "decidim.extra_user_fields.admin")
              redirect_to extra_user_fields_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("signup_fields.update.error", scope: "decidim.extra_user_fields.admin")
              render :edit
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :signup_field

          DestroySignupField.call(signup_field) do
            on(:ok) do
              flash[:notice] = I18n.t("signup_fields.destroy.success", scope: "decidim.extra_user_fields.admin")
            end

            on(:invalid) do
              flash[:alert] = I18n.t("signup_fields.destroy.error", scope: "decidim.extra_user_fields.admin")
            end
          end

          redirect_to extra_user_fields_path
        end

        private

        def signup_field
          @signup_field ||= Decidim::SignupField.find_by(organization: current_organization, id: params[:id])
        end
      end
    end
  end
end
