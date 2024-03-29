require 'rails_helper'

feature 'User can edit his answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:github_url) { 'https://github.com' }

  describe 'Authenticated user', js: true do
    background do
      log_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    context 'Attached files' do
      background do
        within '.answers' do
          click_on 'Edit'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end
      end

      scenario 'asks an answer' do
        click_on 'Edit'

        within '.answers' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'tries to delete his file' do
        within '.answers' do
          first('.attachment').click_on 'Delete file'
          expect(page).to_not have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'tries to add link to his answer' do
      within '.answers' do
        click_on 'Edit'
        click_on 'add link'

        fill_in 'Link name', with: 'Github'
        fill_in 'Url', with: github_url

        click_on 'Save'

        expect(page).to have_link 'Github', href: github_url
      end
    end
  end

  scenario "Authenticated user tries to edit other user's answer" do
    log_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Edit'
  end

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
