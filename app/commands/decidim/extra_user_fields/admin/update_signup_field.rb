# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class UpdateSignupField < Rectify::Command
        def initialize(form)
          @form = form
        end

        def call
          return broadcast(:invalid) if form.invalid?

          update_signup_field
          broadcast(:ok)
        end

        private

        attr_reader :form

        def update_signup_field
          @signup_field = SignupField.find_by(organization: current_organization, id: @form.id)
          return unless @signup_field

          @signup_field.update!(
            organization: current_organization,
            manifest: form.manifest,
            title: translatable_attribute(form.title),
            description: translatable_attribute(form.description),
            mandatory: form.mandatory,
            masked: form.masked,
            options: options_form(form.options)
          )
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
