require 'rails_helper'

feature 'Author can choose the best answer' do
  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create_list(:answer, 2, user: create(:user), question: question) }

  describe 'Authenticated user', js: true do
    scenario 'choose the best answer' do
      log_in(user)
      visit question_path(question)

      within ".answer-#{answer.first.id}" do
        click_on 'Best answer'

        expect(page).to have_content answer.first.body
        expect(page).to_not have_content 'Best answer'
      end
    end

    scenario "can't choose the best answer for the wrong question" do
      log_in(second_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content 'Best answer'
      end
    end
  end

  scenario 'Unauthenticated can not choose the best answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Best answer'
    end
  end
end
