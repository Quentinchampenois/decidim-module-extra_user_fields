# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class CreateSignupFieldsJob < ApplicationJob
        queue_as :default

        def perform(current_organization)
          array = [
            { manifest: "date", title: { I18n.locale => "Date of birth" }, description: { I18n.locale => "Please enter your date of birth" } },
            { manifest: "text", title: { I18n.locale => "Simple question ?" }, description: { I18n.locale => "Please answer this question" } },
            { manifest: "select",
              title: { I18n.locale => "Gender" },
              description: { I18n.locale => "Select a gender" },
              options: [{ "man" => { I18n.locale => "Female" }, "woman" => { I18n.locale => "Male" }, "nonBinary" => { I18n.locale => "Other" } }] }
          ]

          array.map do |model|
            model = Decidim::SignupField.new(organization: current_organization,
                                             manifest: model[:manifest],
                                             title: model[:title],
                                             description: model[:description],
                                             mandatory: true,
                                             masked: true,
                                             options: model.fetch(:options, nil))

            transaction do
              Decidim::ExtraUserFields::Admin::CreateSignupField.call(model)
            end
          end
        end
      end
    end
  end
end
