require 'rails_helper'

feature 'User tries to vote for question' do
  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: second_user) }
  given(:object_name) { question.class.name.underscore }
  given(:path) { question_path(question) }

  it_behaves_like 'Voting'
end
