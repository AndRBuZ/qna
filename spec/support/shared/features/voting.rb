shared_examples_for "Voting" do
  describe 'Authenticated user', js: true do
    background do
      log_in(user)
      visit path
    end

    scenario 'vote up' do
      within ".#{object_name}" do
        expect(page.find('.rating')).to have_content '0'
        click_on 'Upvote'
        expect(page.find('.rating')).to have_content '1'
      end
    end

    scenario 'vote down' do
      within ".#{object_name}" do
        expect(page.find('.rating')).to have_content '0'
        click_on 'Downvote'
        expect(page.find('.rating')).to have_content '-1'
      end
    end

    scenario 'vote up reset' do
      within ".#{object_name}" do
        expect(page.find('.rating')).to have_content '0'
        click_on 'Upvote'
        expect(page.find('.rating')).to have_content '1'
        click_on 'Upvote'
        expect(page.find('.rating')).to have_content '0'
      end
    end

    scenario 'vote down reset' do
      within ".#{object_name}" do
        expect(page.find('.rating')).to have_content '0'
        click_on 'Downvote'
        expect(page.find('.rating')).to have_content '-1'
        click_on 'Downvote'
        expect(page.find('.rating')).to have_content '0'
      end
    end
  end

  describe 'User is author', js: true do
    before do
      log_in(second_user)
      visit path
    end

    scenario 'tries to vote' do
      within ".#{object_name}" do
        expect(page).to_not have_content 'Upvote'
        expect(page).to_not have_content 'Downvote'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    before do
      visit path
    end

    scenario do
      within ".#{object_name}" do
        expect(page).to_not have_content 'Upvote'
        expect(page).to_not have_content 'Downvote'
      end
    end
  end
end
