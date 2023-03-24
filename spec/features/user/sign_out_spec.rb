require 'rails_helper'

feature 'User can sign out' do

  given(:user) { create(:user)}

  scenario 'Registered user tries to sign out' do
     log_in(user)
     expect(page).to have_content 'Signed in successfully.'
     click_on 'Sign out'
     expect(page).to have_content 'Signed out successfully.'
  end
end
