require 'rails_helper'

feature 'User can delete answer' do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    scenario 'tries to delete his answer' do
      log_in(user)
      visit question_path(question)
      within '.answers' do
        click_on 'Delete answer'

        expect(page).to_not have_content answer.body
      end
    end

    scenario 'tries to delete not his answer' do
      log_in(second_user)
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_content 'Delete answer'
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Delete answer'
    end
  end
end
