# frozen_string_literal: true

User.destroy_all
User.create!(
  email: 'demouser@example.com',
  password: '12345678Aa$',
  confirmed_at: Time.now,
  company_owner: true
)
