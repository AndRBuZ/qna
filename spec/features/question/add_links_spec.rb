require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/AndRBuZ/332b369d8166faa123bbc780a01f7489' }
  given(:github_url) { 'https://github.com' }

  describe 'Authenticated user', js: true do
    background do
      log_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'
    end

    scenario 'adds link when asks a question' do
      click_on 'add link'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'User adds links when asks a question' do
      click_on 'add link'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Github'
        fill_in 'Url', with: github_url
      end

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Github', href: github_url
    end

    scenario 'user tries add link with errors' do
      click_on 'add link'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'gist.github.com'
      click_on 'Ask'

      expect(page).to have_content 'Links url is invalid'
    end
  end
end
