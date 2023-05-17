require 'rails_helper'

feature 'User can delete links from question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, name: 'github', url: 'https://github.com', linkable: question) }

  describe 'Authenticated user', js: true do
    background do
      log_in(user)
      visit question_path(question)
    end

    scenario 'can delete his link' do
      within '.question' do
        click_on 'Delete link'
        expect(page).to_not have_link link.name, href: link.url
      end
    end
  end
end
