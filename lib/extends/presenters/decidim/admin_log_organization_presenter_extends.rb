# frozen_string_literal: true

require "active_support/concern"

module OrganizationPresenterExtends
  extend ActiveSupport::Concern

  included do
    private

    def diff_fields_mapping
      settings_attributes_mapping
        .merge(omnipresent_banner_attributes_mapping)
        .merge(highlighted_content_banner_attributes_mapping)
        .merge(appearance_attributes_mapping)
        .merge(id_documents_attributes_mapping)
        .merge(extra_user_fields_attributes_mapping)
    end

    def extra_user_fields_attributes_mapping
      {
        extra_user_fields: :string
      }
    end

    def action_string
      case action
      when "update_id_documents_config", "update_extra_user_fields", "export_users"
        "decidim.admin_log.organization.#{action}"
      else
        "decidim.admin_log.organization.update"
      end
    end

    def diff_actions
      super + %w(update_id_documents_config update_extra_user_fields)
    end
  end
end
