require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions/:id/answers' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:resource_response) { json['answers'].first }
      let(:resource) { answers.first }
      let(:public_fields) { %w[id body best created_at updated_at] }

      it_behaves_like 'GET collection'

      it 'returns list of questions' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        expect(json['answers'].size).to eq 3
      end
    end
  end

  describe 'GET /api/v1/questions/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let(:file1) { "#{Rails.root}/spec/rails_helper.rb" }
    # let(:file2) { ("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:comments) { create_list(:comment, 3, commentable: answer) }
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before do
      fixture_file_upload(file1)
    end

    context 'authorized' do
      let(:resource_response) { json['answer'] }
      let(:resource) { answer }
      let(:public_fields) { %w[id body best created_at updated_at] }

      it_behaves_like 'GET resource'

      it 'return answer' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        expect(json['answer'].size).to eq 8
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:access_token) { create(:access_token) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'valid params' do
        let(:answer_params) do
          {
            user_id: user.id,
            body: 'Question body',
            links_attributes: [
              {
                name: 'Google',
                url: 'https://google.com'
              }
            ]
          }
        end

        it 'return 200' do
          post api_path, params: { answer: answer_params, access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'saves a new answer' do
          expect do
            post api_path, params: { answer: answer_params, access_token: access_token.token }, headers: headers
          end.to change(Answer, :count).by(1)
        end
      end

      context 'invalid params' do
        let(:answer_params) do
          {
            user_id: user.id,
            title: '',
            body: '',
            links_attributes: [
              {
                name: 'Google',
                url: 'https://google.com'
              }
            ]
          }
        end

        it 'does not save a answer' do
          expect do
            post api_path, params: { answer: answer_params, access_token: access_token.token }, headers: headers
          end.to_not change(Answer, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question)}
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'valid params' do
        let(:answer_params) do
          {
            user_id: user.id,
            body: 'new body',
            links_attributes: [
              {
                name: 'Google',
                url: 'https://google.com'
              }
            ]
          }
        end

        it 'return 200' do
          patch api_path, params: { answer: answer_params, access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'change questions attributes' do
          patch api_path, params: { answer: answer_params, access_token: access_token.token }, headers: headers
          answer.reload

          expect(answer.body).to eq 'new body'
        end
      end

      context 'invalid params' do
        let(:answer_params) do
          {
            user_id: user.id,
            body: '',
            links_attributes: [
              {
                name: 'Google',
                url: 'https://google.com'
              }
            ]
          }
        end

        it 'does not change question' do
          patch api_path, params: { answer: answer_params, access_token: access_token.token }, headers: headers
          answer.reload

          expect(answer.body).to eq answer.body
        end
      end
    end
  end

  describe 'DELETE /api/v1/question/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'Authenticated user' do
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }
        let(:params) do
          { user_id: user.id }
        end

        it 'deletes the question' do
          expect do
            delete api_path, params: { answer: params, access_token: access_token.token }, headers: headers
          end.to change(Answer, :count).by(-1)
        end
      end

      context 'Unauthenticated user' do
        let(:other_user) { create :user }
        let(:access_token) { create(:access_token, resource_owner_id: other_user.id) }
        let(:params) do
          { user_id: other_user.id }
        end

        it 'does not deletes the question' do
          expect do
            delete api_path, params: { answer: params, access_token: access_token.token }, headers: headers
          end.to_not change(Answer, :count)
        end
      end
    end
  end
end
