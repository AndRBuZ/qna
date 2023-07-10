require 'sphinx_helper'

feature 'User can search question' do
  given!(:user) { create :user }

  before { visit root_path }

  scenario 'can find question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: user.email
      choose 'User'

      click_on 'Search'

      expect(page).to have_content user.email
    end
  end

  scenario 'can not find question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'User'

      click_on 'Search'

      expect(page).to_not have_content user.email
      expect(page).to have_content 'Nothing found'
    end
  end

  scenario 'with all scope', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: user.email

      click_on 'Search'

      expect(page).to have_content user.email
    end
  end
end
