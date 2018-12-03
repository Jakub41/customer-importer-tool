# frozen_string_literal: true

module LoginHelpers
  def login_with(user)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: '12345678'
    click_button 'Log In'

    expect(page).to have_link 'Log out'
  end
end
