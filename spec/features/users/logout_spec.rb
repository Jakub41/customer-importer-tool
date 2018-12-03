# frozen_string_literal: true

require 'rails_helper'

describe 'Logout' do
  let!(:user) { create(:user) }

  before do
    sign_in user
    visit root_path
  end

  it 'log out' do
    click_on 'Log out'
    expect(page).to_not have_link 'Log out'
  end
end
