require 'rails_helper'

feature 'User can delete answer' do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'tries to delete his answer' do
      log_in(user)
      visit question_path(question)
      click_on 'Delete answer'
      save_and_open_page

      expect(page).to have_content 'Your answer was successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'tries to delete not his answer' do
      log_in(second_user)
      visit question_path(question)

      expect(page).to_not have_content 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to ask a answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
