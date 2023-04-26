# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class SignupFieldsForm < Decidim::Form
        attribute :manifest, String
        attribute :title, String
        attribute :description, String
        attribute :options, String
        attribute :mandatory, Virtus::Attribute::Boolean
        attribute :masked, Virtus::Attribute::Boolean

        def available_fields
          %w(text textarea date select checkbox radio).freeze
        end

        def get_signup_id(signup_field)
          signup_field.id if signup_field
        end

        def get_signup_title(signup_field)
          signup_field.title[I18n.locale.to_s] if signup_field
        end

        def get_signup_manifest(signup_field)
          signup_field.manifest if signup_field
        end

        def get_signup_description(signup_field)
          signup_field.description[I18n.locale.to_s] if signup_field
        end

        def get_signup_options(signup_field)
          signup_field_show_options(signup_field) if signup_field
        end

        def warning_text?(signup_field)
          return unless signup_field

          I18n.t("decidim.extra_user_fields.admin.signup_fields.warning_text", language: I18n.locale.to_s)
        end

        def signup_field_show_options(signup_field)
          current_locale = I18n.locale.to_s
          options = signup_field.options.map { |option| option[current_locale] if option.has_key?(current_locale) }.compact
          # Stringify them and join them with a comma
          options.map(&:to_s).join(", ")
        end

        # Function to "translate" each of the available fields into a human-readable -> text -> Short Text
        def translated_available_fields
          field_translations = {
            "text" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.short_text"),
            "textarea" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.long_text"),
            "date" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.date"),
            "select" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.select"),
            "checkbox" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.checkbox"),
            "radio" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.radio")
          }

          available_fields.map { |field| field_translations[field] }
        end
      end
    end
  end
end
