# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class UpdateSignupField < Rectify::Command
        def initialize(form)
          @form = form
        end

        def call
          return broadcast(:invalid, form) if form.invalid?
          return broadcast(:not_found, form) if signup_field.blank?
          return broadcast(:invalid, form) if signup_field.invalid?

          transaction do
            update_signup_field!
          end

          broadcast(:ok)
        end

        private

        attr_reader :form

        def update_signup_field!
          signup_field.update!(
            organization: form.organization,
            manifest: form.manifest,
            title: translatable_attribute(form.title),
            description: translatable_attribute(form.description),
            mandatory: form.mandatory,
            masked: form.masked,
            options: options_form(form.options)
          )
        end

        def signup_field
          @signup_field ||= SignupField.find_by(organization: form.organization, id: @form.id)
        end

        def translatable_attribute(attribute)
          {
            I18n.locale => attribute
          }
        end

        def options_form(options)
          return unless options

          options.split(",").map { |option| translatable_attribute(option.strip) }
        end
      end
    end
  end
end
