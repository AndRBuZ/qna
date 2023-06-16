require 'rails_helper'

feature 'User tries add comment to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background do
      log_in(user)
      visit question_path(question)
    end

    scenario 'user can add comment to answer' do
      within '.answers' do
        fill_in 'Your comment:', with: 'Test comment'
        click_on 'Send comment'

        expect(page).to have_content 'Test comment'
      end
    end

    scenario 'user tries add comment to answer with errors' do
      within '.answers' do
        click_on 'Send comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'miltiple sessions' do
    scenario "answer's comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        log_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Your comment:', with: 'Test comment'
          click_on 'Send comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Your comment:'
      expect(page).to_not have_content 'Send comment'
    end
  end
end
