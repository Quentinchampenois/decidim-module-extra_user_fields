# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class SignupFieldsForm < Decidim::Form
        attribute :manifest, String
        attribute :title, String
        attribute :description, String
        attribute :options, Array[String]
        attribute :mandatory, Virtus::Attribute::Boolean
        attribute :masked, Virtus::Attribute::Boolean

        def available_fields
          %w(text textarea date select checkbox radio).freeze
        end

        # Function to "translate" each of the available fields into a human-readable -> text -> Short Text
        def translated_available_fields
          field_translations = {
            "text" => "Short Text",
            "textarea" => "Long Text",
            "date" => "Date",
            "select" => "Dropdown",
            "checkbox" => "Checkbox",
            "radio" => "Radio Button"
          }

          available_fields.map { |field| field_translations[field] }
        end
      end
    end
  end
end
