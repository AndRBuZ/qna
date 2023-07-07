require 'rails_helper'

feature 'The user can subscribe to question' do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:subscribed_question) { create(:question) }
  given!(:subscription) { create(:subscription, user: user, question: subscribed_question) }

  context 'Authenticated user' do
    before { log_in(user) }

    scenario 'can subscribe to question', js: true do
      visit question_path(question)

      expect(page).to have_link 'subscribe'

      click_on 'subscribe'

      expect(page).to have_link 'unsubscribe'
    end

    scenario 'can unsubscribe to question', js: true do
      visit question_path(subscribed_question)

      expect(page).to have_link 'unsubscribe'

      click_on 'unsubscribe'

      expect(page).to have_link 'subscribe'
    end
  end

  scenario "Unauthenticated user can't see the subscribe link", js: true do
    visit question_path(question)

    expect(page).to_not have_link 'subscribe'
    expect(page).to_not have_link 'unsubscribe'
  end
end
