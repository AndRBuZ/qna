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
        mock_auth :github, 'test@example.com'
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from github account.'
      end
    end

    context 'vkontakte' do
      scenario 'can sign in' do
        mock_auth :vkontakte
        click_on 'Sign in with Vkontakte'

        fill_in 'email', with: 'test@test.com'
        click_on 'Send'

        open_email('test@test.com')
        current_email.click_link 'Confirm your registration'


        expect(page).to have_content 'Email successfully confirmed'
      end
    end
  end
end
