# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :company
  belongs_to :user, required: false

  scope :ordered, -> { order id: :asc }

  validates :name, presence: true

  delegate :email, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :company, prefix: true, allow_nil: true

  def country_name
    return nil if country_code.blank?

    ISO3166::Country.new(country_code.strip).to_s
  end
end
