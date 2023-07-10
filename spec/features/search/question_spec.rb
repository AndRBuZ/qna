require 'sphinx_helper'

feature 'User can search question' do
  given!(:question) { create :question }

  before { visit root_path }

  scenario 'can find question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: question.title
      choose 'Question'

      click_on 'Search'

      expect(page).to have_content question.title
    end
  end

  scenario 'can not find question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'Question'

      click_on 'Search'

      expect(page).to_not have_content question.title
      expect(page).to have_content 'Nothing found'
    end
  end

  scenario 'with all scope', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: question.title

      click_on 'Search'

      expect(page).to have_content question.title
    end
  end
end
