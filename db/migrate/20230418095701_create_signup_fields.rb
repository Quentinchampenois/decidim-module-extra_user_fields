# frozen_string_literal: true

class CreateSignupFields < ActiveRecord::Migration[6.0]
  def up
    create_table :decidim_signup_fields do |t|
      t.string :manifest
      t.jsonb :title
      t.jsonb :description
      t.boolean :mandatory, default: true
      t.boolean :masked, default: true
      t.jsonb :options, null: true

      t.references :decidim_organization
    end
  end

  def down
    drop_table :decidim_signup_fields, if_exists: true
  end
end
