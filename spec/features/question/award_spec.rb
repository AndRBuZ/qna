require 'rails_helper'

feature 'User can add award to his question'do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      log_in(user)

      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'asks a question with added award' do
      within '.award' do
        fill_in 'Award title', with: 'Award'
        attach_file 'Image', "#{Rails.root}/spec/images/golden-star.png"
      end
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      within '.award' do
        attach_file 'Image', "#{Rails.root}/spec/images/golden-star.png"
      end
      click_on 'Ask'

      expect(page).to have_content "Award title can't be blank"
    end
  end
end
