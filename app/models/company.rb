# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :customers, dependent: :destroy

  validates :name, presence: true
end
