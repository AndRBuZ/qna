require 'rails_helper'

feature 'User tries add comment to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      log_in(user)
      visit question_path(question)
    end

    scenario 'user can add comment to question' do
      fill_in 'Your comment:', with: 'Test comment'
      click_on 'Send comment'

      expect(page).to have_content 'Test comment'
    end

    scenario 'user tries add comment to question with errors' do
      click_on 'Send comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'miltiple sessions' do
    scenario "question's comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        log_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your comment:', with: 'Test comment'
        click_on 'Send comment'

        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)

    expect(page).to_not have_content 'Your comment:'
    expect(page).to_not have_content 'Send comment'
  end
end
