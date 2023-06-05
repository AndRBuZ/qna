require 'rails_helper'

feature 'User tries to vote for question' do
  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: second_user) }

  describe 'Authenticated user', js: true do
    background do
      log_in(user)
      visit question_path(question)
    end

    scenario 'vote up' do
      within '.question' do
        expect(page.find('.rating')).to have_content '0'
        click_on 'Upvote'
        expect(page.find('.rating')).to have_content '1'
      end
    end

    scenario 'vote down' do
      within '.question' do
        expect(page.find('.rating')).to have_content '0'
        click_on 'Downvote'
        expect(page.find('.rating')).to have_content '-1'
      end
    end

    scenario 'vote up reset' do
      within '.question' do
        expect(page.find('.rating')).to have_content '0'
        click_on 'Upvote'
        expect(page.find('.rating')).to have_content '1'
        click_on 'Upvote'
        expect(page.find('.rating')).to have_content '0'
      end
    end

    scenario 'vote down reset' do
      within '.question' do
        expect(page.find('.rating')).to have_content '0'
        click_on 'Downvote'
        expect(page.find('.rating')).to have_content '-1'
        click_on 'Downvote'
        expect(page.find('.rating')).to have_content '0'
      end
    end
  end

  scenario 'Author tries to vote', js: true do
    log_in(second_user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_content 'Upvote'
      expect(page).to_not have_content 'Downvote'
    end
  end

  scenario 'Unauthenticated user tries to vote', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Upvote'
    expect(page).to_not have_content 'Downvote'
  end
end
