require 'sphinx_helper'

feature 'User can search comment' do
  given!(:question) { create :question }
  given!(:answer) { create :answer }
  given!(:comment_1) { create :comment, commentable: question }
  given!(:comment_2) { create :comment, commentable: answer }

  before { visit root_path }

  scenario 'can find comment question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: comment_1.body
      choose 'Comment'

      click_on 'Search'

      expect(page).to have_content comment_1.commentable.title
    end
  end

  scenario 'can find comment answer', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: comment_2.body
      choose 'Comment'

      click_on 'Search'

      expect(page).to have_content comment_2.commentable.body
    end
  end

  scenario 'can not find comment', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'Comment'

      click_on 'Search'

      expect(page).to_not have_content comment_1.commentable.title
      expect(page).to_not have_content comment_2.commentable.body
      expect(page).to have_content 'Nothing found'
    end
  end

  scenario 'with all scope question comment', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: comment_1.body

      click_on 'Search'

      expect(page).to have_content comment_1.commentable.title
    end
  end

  scenario 'with all scope answer comment', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: comment_2.body

      click_on 'Search'

      expect(page).to have_content comment_2.commentable.body
    end
  end
end
