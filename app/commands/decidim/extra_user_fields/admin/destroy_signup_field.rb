# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class DestroySignupField < Rectify::Command
        def initialize(form)
          @form = form
        end

        def call
          return broadcast(:invalid, form) if form.invalid?
          return broadcast(:not_found, form) if signup_field.blank?
          return broadcast(:invalid, form) if signup_field.invalid?

          transaction do
            destroy_signup_field!
          end

          broadcast(:ok)
        end

        private

        attr_reader :form

        def destroy_signup_field!
          signup_field.destroy!
        end

        def signup_field
          @signup_field ||= SignupField.find_by(organization: current_organization, id: @form.id)
        end
      end
    end
  end
end
