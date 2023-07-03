shared_examples_for 'Commenting' do
  describe 'Authenticated user', js: true do
    background do
      log_in(user)
      visit path
    end

    scenario 'user can add comment to oject' do
      within ".#{object_name}" do
        fill_in 'Your comment:', with: 'Test comment'
        click_on 'Send comment'

        expect(page).to have_content 'Test comment'
      end
    end

    scenario 'user tries add comment to object with errors' do
      within ".#{object_name}" do
        click_on 'Send comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'miltiple sessions' do
    scenario "object's comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        log_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ".#{object_name}" do
          fill_in 'Your comment:', with: 'Test comment'
          click_on 'Send comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        within ".#{object_name}" do
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to add comment' do
    visit question_path(question)

    within ".#{object_name}" do
      expect(page).to_not have_content 'Your comment:'
      expect(page).to_not have_content 'Send comment'
    end
  end
end
