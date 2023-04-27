# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class SignupFieldsForm < Decidim::Form
        include TranslatableAttributes

        translatable_attribute :title, String
        translatable_attribute :description, String
        attribute :manifest, String
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
          options.map(&:to_s).join(", ")
        end

        def translated_available_fields
          [
            { "manifest" => "text", "name" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.short_text") },
            { "manifest" => "textarea", "name" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.long_text") },
            { "manifest" => "date", "name" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.date") },
            { "manifest" => "select", "name" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.select") },
            { "manifest" => "checkbox", "name" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.checkbox") },
            { "manifest" => "radio", "name" => I18n.t("decidim.extra_user_fields.admin.signup_fields.options.radio") }
          ]
        end

        def translated_field(manifest, signup_field)
          manifest = signup_field.manifest if signup_field
          field = translated_available_fields.find { |available_field| manifest == available_field["manifest"] }
          field["name"]
        end
      end
    end
  end
end
