# frozen_string_literal: true

require 'rails_helper'

describe 'Login' do
  let!(:user) { create(:user, :company_owner) }

  context 'with valid email/password' do
    it 'allows login' do
      visit root_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Log In'

      expect(page).to have_content 'Signed in successfully.'
      expect(page).to have_link 'Log out'
    end
  end
end
