require 'rails_helper'

feature 'User tries add comment to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:object_name) { question.class.name.underscore }
  given(:path) { question_path(question) }

  it_behaves_like 'Commenting'
end
