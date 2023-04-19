# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class CreateSignupFieldsJob < ApplicationJob
        queue_as :default
        def perform(current_organization)
          array =
            [
              Decidim::SignupField.new(organization: current_organization,
                                       manifest: "date", title: { "en" => "Date of Birth" },
                                       description: { "en" => "Please enter your date of birth" },
                                       mandatory: true,
                                       masked: true,
                                       options: nil),

              Decidim::SignupField.new(organization: current_organization,
                                       manifest: "select", title: { "en" => "Gender" },
                                       description: { "en" => "Please select your gender" },
                                       mandatory: true,
                                       masked: true,
                                       options: [{ "man": { en: "Man", fr: "Homme" },
                                                   "woman": { en: "Woman", fr: "Femme" },
                                                   "nonBinary": { en: "Non Binary", fr: "Non binaire" } }])
            ]

          array.each { |model| Decidim::ExtraUserFields::Admin::CreateSignupField.call(model) }
        end
      end
    end
  end
end
