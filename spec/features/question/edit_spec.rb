require 'rails_helper'

feature 'User can edit his question' do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do
    background do
      log_in(question.user)
      visit question_path(question)
    end

    scenario 'edits his question' do
      click_on 'Edit Question'

      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      click_on 'Edit Question'

      within '.question' do
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
      end
    end
  end

  scenario "Authenticated user tries to edit other user's answer" do
    log_in(second_user)
    visit question_path(question)

    expect(page).to_not have_content 'Edit Question'
  end

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit Qusetion'
  end
end
