require 'rails_helper'

feature 'The user can see the questions with answers' do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }

  scenario 'Authenticated user can see the question with answers' do
    log_in(user)
    visit question_path(answer.question)

    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

  scenario 'Unauthenticated user can see the question with answers' do
    visit question_path(answer.question)

    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end
