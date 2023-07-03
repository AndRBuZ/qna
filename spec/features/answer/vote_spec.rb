require 'rails_helper'

feature 'User tries to vote for answer' do
  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: second_user, question: question) }
  given(:object_name) { answer.class.name.underscore.pluralize }
  given(:path) { question_path(question) }

  it_behaves_like 'Voting'
end
