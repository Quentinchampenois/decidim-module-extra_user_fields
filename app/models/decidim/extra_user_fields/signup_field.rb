# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    # Field which is loaded in the signup form as extra field.
    class SignupField < ApplicationRecord
      include Decidim::Publicable
      include Decidim::TranslatableResource

      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

      attribute :type, String
      translatable_fields :title, :description
      attribute :mandatory, Virtus::Attribute::Boolean
      attribute :public, Virtus::Attribute::Boolean

      AVAILABLE_TYPES = %w(text textarea date select checkbox radio).freeze

      validates :type, inclusion: { in: AVAILABLE_TYPES }
      validates :title, presence: true, uniqueness: { scope: :organization }
      validates :description, presence: true
      validates :mandatory, inclusion: { in: [true, false] }
      validates :public, inclusion: { in: [true, false] }

      # Public: finds the published signup field for the given scope and
      # organization. Returns them ordered by ascending weight (lowest first).
      def self.for_scope(organization:)
        where(organization: organization).order(weight: :asc)
      end

      # def manifest
      #   @manifest ||= Decidim::ExtraUserFields.manifests.find { |manifest| manifest.name == type }
      # end
    end
  end
end
