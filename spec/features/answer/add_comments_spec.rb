require 'rails_helper'

feature 'User tries add comment to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:object_name) { answer.class.name.underscore.pluralize }
  given(:path) { question_path(question) }

  it_behaves_like 'Commenting'
end
