# frozen_string_literal: true

require "decidim/extra_user_fields/admin"
require "decidim/extra_user_fields/engine"
require "decidim/extra_user_fields/admin_engine"
require "decidim/extra_user_fields/form_builder_methods"

module Decidim
  # This namespace holds the logic of the `ExtraUserFields` module.
  module ExtraUserFields
    include ActiveSupport::Configurable

    config_accessor :notifications_sending_frequency do
      ENV.fetch("NOTIFICATIONS_SENDING_FREQUENCY", "daily")
    end
  end
end
