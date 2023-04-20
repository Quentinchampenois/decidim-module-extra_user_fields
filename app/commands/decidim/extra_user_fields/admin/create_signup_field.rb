# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      # A command with all the business logic when updating organization's extra user fields in signup form
      # TODO: Update Rectify::Command to Decidim::Command for v0.28
      class CreateSignupField < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the model wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          create_signup_field
          broadcast(:ok)
        end

        private

        attr_reader :form

        def create_signup_field
          @signup_field = SignupField.create!(
            organization: current_organization,
            manifest: form.manifest,
            title: translatable_attribute(form.title),
            description: translatable_attribute(form.description),
            mandatory: form.mandatory,
            masked: form.masked,
            options: form.options
          )
        end

        def translatable_attribute(attribute)
          {
            I18n.locale => attribute
          }
        end
      end
    end
  end
end
