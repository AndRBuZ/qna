require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do
  given(:user) { User.create!(email: 'user@test.com', password: '12345678') }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content "Invalid Email or password."
  end

  context 'Registered user with OAuth' do
    context 'GitHub' do
      scenario 'can sign in' do
        mock_auth_hash
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'user not sing in' do
        mock_auth_invalid
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub because "Credentials are invalid"'
      end
    end
  end
end
