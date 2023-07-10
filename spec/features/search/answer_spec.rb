require 'sphinx_helper'

feature 'User can search answer' do
  given!(:answer) { create :answer }

  before { visit root_path }

  scenario 'can find answer', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: answer.body
      choose 'Answer'

      click_on 'Search'

      expect(page).to have_content answer.question.title
    end
  end

  scenario 'can not find answer', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'Answer'

      click_on 'Search'

      expect(page).to_not have_content answer.question.title
      expect(page).to have_content 'Nothing found'
    end
  end

  scenario 'with all scope', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: answer.body

      click_on 'Search'

      expect(page).to have_content answer.question.title
    end
  end
end
