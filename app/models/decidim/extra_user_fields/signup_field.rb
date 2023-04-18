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

      # Public: finds the published content blocks for the given scope and
      # organization. Returns them ordered by ascending weight (lowest first).
      def self.for_scope(organization:)
        where(organization: organization).order(weight: :asc)
      end

      def manifest
        @manifest ||= Decidim.content_blocks.for(scope_name).find { |manifest| manifest.name.to_s == manifest_name }
      end
    end
  end
end
