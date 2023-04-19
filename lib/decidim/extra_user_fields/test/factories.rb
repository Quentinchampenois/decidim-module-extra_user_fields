# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :extra_user_fields_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :extra_user_fields).i18n_name }
    manifest_name { :extra_user_fields }
    participatory_space { create(:participatory_process, :with_steps) }
  end

  factory :signup_field, class: "Decidim::SignupField" do
    organization { create(:organization) }
    manifest { "text" }
    title { generate_localized_title }
    description { generate_localized_title }
    mandatory { true }
    masked { true }
    options { nil }
    published_at { Time.zone.now }
    weight { 0 }

    trait :with_options do
      options do
        [
          {
            label: generate_localized_title,
            value: "option-1"
          },
          {
            label: generate_localized_title,
            value: "option-2"
          },
          {
            label: generate_localized_title,
            value: "option-3"
          }
        ]
      end
    end

    trait :inactive do
      published_at { nil }
    end
  end
end
