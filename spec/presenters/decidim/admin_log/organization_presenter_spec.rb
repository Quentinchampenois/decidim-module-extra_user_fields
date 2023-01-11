# frozen_string_literal: true

require "spec_helper"

describe Decidim::AdminLog::OrganizationPresenter, type: :helper do
  include_examples "present admin log entry" do
    let(:admin_log_resource) { organization }
    let(:action) { "update_id_documents_config" }
  end

  include_examples "present admin log entry" do
    let(:admin_log_resource) { organization }
    let(:action) { "update_extra_user_fields" }
  end

  include_examples "present admin log entry" do
    let(:admin_log_resource) { organization }
    let(:action) { "update" }
  end

  describe "when the action is update_extra_user_fields" do
    let(:action) { "update_extra_user_fields" }
    let(:extra_user_fields) { true }

    it "renders the extra user fields custom message" do
      expect(subject.present).to include("has updated the signup form through extra user fields")
    end
  end

  describe "when the action is export_users" do
    let(:action) { "export_users" }

    it "renders the export users custom message" do
      expect(subject.present).to include("has exported the users")
    end
  end
end
