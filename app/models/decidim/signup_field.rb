# frozen_string_literal: true

module Decidim
  # Field which is loaded in the signup form as extra field.
  class SignupField < ApplicationRecord
    include Decidim::Publicable
    include Decidim::TranslatableResource

    belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

    attribute :manifest, :string
    translatable_fields :title, :description
    attribute :mandatory, :boolean
    attribute :masked, :boolean
    attribute :options, :jsonb

    AVAILABLE_TYPES = %w(text textarea date select checkbox radio).freeze
    OPTIONS_FOR_TYPES = %w(checkbox radio select).freeze

    validates :manifest, inclusion: { in: AVAILABLE_TYPES }
    validates :title, presence: true, uniqueness: { scope: :organization }
    validates :description, presence: true
    validates :mandatory, inclusion: { in: [true, false] }
    validates :masked, inclusion: { in: [true, false] }

    # If manifest is checkbox, radio or select then options must be present
    # validates :options, presence: true, if: -> { OPTIONS_FOR_TYPES.include?(manifest) }

    # Public: finds the published signup field for the given scope and
    # organization. Returns them ordered by ascending weight (lowest first).
    def self.for_scope(organization:)
      where(organization: organization).order(weight: :asc)
    end

    # def manifest
    #   @manifest ||= Decidim::ExtraUserFields.manifests.find { |manifest| manifest.name == manifest }
    # end
  end
end
