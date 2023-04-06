require 'rails_helper'

feature 'User can delete question', js: true do
  given(:user) { create(:user) }
  given!(:question) { create_list(:question, 2) }

  describe 'Authenticated user' do
    background { log_in(question[0].user) }

    scenario 'tries to delete his question' do
      visit question_path(question[0])
      click_on 'Delete question'

      expect(page).to_not have_content question[0].title
    end

    scenario 'tries to delete not his question' do
      visit question_path(question[1])

      expect(page).to_not have_content 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question[0])

    expect(page).to_not have_content 'Delete question'
  end
end
