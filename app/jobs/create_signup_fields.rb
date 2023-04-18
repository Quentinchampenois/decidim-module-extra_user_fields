# frozen_string_literal: true

module Decidim
  class CreateUserFields < ApplicationJob
    queue_as :default

    def perform(current_organization)
      Decidim::ExtraUserFields::SignupField.create(
        organization: current_organization,
        type: "date",
        title: "Date of Birth",
        description: "Please enter your date of birth",
        mandatory: true,
        public: true,
        options: {} # Add options here
      )

      Decidim::ExtraUserFields::SignupField.create(
        organization: current_organization,
        type: "select",
        title: "Gender",
        description: "Please select your gender",
        mandatory: true,
        public: true,
        options: { "man": "Homme", "woman": "Femme", "nonBinary": "Non Défini" } # Add options here
      )

      Decidim::ExtraUserFields::SignupField.create(
        organization: current_organization,
        type: "custom_country_select",
        title: "Country",
        description: "Please select your country",
        mandatory: true,
        public: true,
        options: {} # Add options here
      )

      Decidim::ExtraUserFields::SignupField.create(
        organization: current_organization,
        type: "text",
        title: "Postal Code",
        description: "Please enter your postal code",
        mandatory: true,
        public: true,
        options: {} # Add options here
      )
    end
  end
end
