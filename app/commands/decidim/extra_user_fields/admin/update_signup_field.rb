# frozen_string_literal: true

class UpdateSignupField

  def initialize
    @form = form
  end

  def call
    return broadcast(:invalid) if form.invalid?

    update_signup_field
    broadcast(:ok)
  end

  private

  attr_reader :form

  def update_signup_field
    @signup_field = SignupField.update!(
      organization: current_organization,
      manifest: form.manifest,
      title: translatable_attribute(form.title),
      description: translatable_attribute(form.description),
      mandatory: form.mandatory,
      masked: form.masked,
      options: options_form(form.options)
    )
  end
end
