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
        def initialize(model)
          @model = model
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the model wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if model.invalid?

          create_signup_field
          broadcast(:ok)
        end

        private

        attr_reader :model

        def create_signup_field
          @signup_field = SignupField.create!(
            organization: model.organization,
            manifest: model.manifest,
            title: model.title,
            description: model.description,
            mandatory: model.mandatory,
            masked: model.masked,
            options: model.options
          )
        end
      end
    end
  end
end
