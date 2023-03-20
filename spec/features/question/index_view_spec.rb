require 'rails_helper'

feature 'The user can see the list of questions' do

  given(:user) { create(:user) }
  given!(:question) { create_list(:question, 2) }

  scenario 'Authenticated user can see the list of questions' do
    log_in(user)
    visit questions_path

    expect(page).to have_content question[0].title
    expect(page).to have_content question[1].title
  end

  scenario 'Unauthenticated user can see the list of questions' do
    visit questions_path

    expect(page).to have_content question[0].title
    expect(page).to have_content question[1].title
  end
end
