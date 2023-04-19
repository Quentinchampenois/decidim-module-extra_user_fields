# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class ExtraUserFieldsForm < Decidim::Form
        attribute :field_ids, Array

        validate :field_in_organization

        private

        def field_in_organization
          return if current_organization.blank?
          return if field_ids.blank?

          errors.add(:not_authorized) unless fields_found?
        end

        def fields_found?
          fields.count == field_ids.count
        end

        def fields
          @fields ||= Decidim::SignupField.get_fields(field_ids, current_organization)
        end
      end
    end
  end
end
