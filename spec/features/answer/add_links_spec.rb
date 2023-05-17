require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/AndRBuZ/332b369d8166faa123bbc780a01f7489' }

  describe 'Authenticated user', js: true do
    background do
      log_in(user)
      visit question_path(question)

      fill_in 'Your answer', with: 'My answer'

      click_on 'add link'
    end

    scenario 'adds link when asks a question' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end

    scenario 'user tries add link with errors' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'gist.github.com'

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_content 'Links url is invalid'
      end
    end
  end
end
