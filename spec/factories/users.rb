# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password { '12345678Aa$' }
    confirmed_at { Time.now }

    trait :company_owner do
      company_owner { true }
    end
  end
end
