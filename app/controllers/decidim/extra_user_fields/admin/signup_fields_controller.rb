# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class SignupFieldsController < Admin::ApplicationController
        def new
          enforce_permission_to :read, :extra_user_fields

          @form = Decidim::ExtraUserFields::Admin::SignupFieldsForm.new
        end

        def create
          # enforce_permission_to :create, :extra_user_fields

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
      end
    end
  end
end
