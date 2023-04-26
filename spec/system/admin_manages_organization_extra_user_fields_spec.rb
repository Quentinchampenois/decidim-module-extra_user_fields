# frozen_string_literal: true

require "spec_helper"

describe "Admin manages organization extra user fields", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  it "creates a new item in submenu" do
    visit decidim_admin.edit_organization_path

    within ".secondary-nav" do
      expect(page).to have_content("Manage extra user fields")
    end
  end

  context "when accessing extra user fields" do
    before do
      visit decidim_extra_user_fields.root_path
    end

    it "allows to create a new extra field" do
      within "#extra_user_fields" do
        expect(page).to have_link("New extra user field")
      end
    end

    it "display drag and drop elements" do
      within "#submit_extra_fields" do
        expect(page).to have_content("Active fields")
        expect(page).to have_content("Inactive fields")
      end
    end

    it "form can be submitted" do
      within "#submit_extra_fields" do
        expect(page).to have_button("Save configuration")
      end
    end
  end
end
