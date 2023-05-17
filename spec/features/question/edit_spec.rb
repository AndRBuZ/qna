require 'rails_helper'

feature 'User can edit his question' do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:github_url) { 'https://github.com' }

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

    context 'Attached files' do
      background do
        within '.question' do
          click_on 'Edit Question'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end
      end

      scenario 'edits his with add files' do
        within '.question' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'tries to delete his file' do
        within '.question' do
          first('.attachment').click_on 'Delete file'
          expect(page).to_not have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'tries to add link to his question' do
      within '.question' do
        click_on 'Edit Question'
        click_on 'add link'

        fill_in 'Link name', with: 'Github'
        fill_in 'Url', with: github_url

        click_on 'Save'

        expect(page).to have_link 'Github', href: github_url
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
