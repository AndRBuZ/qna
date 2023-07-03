require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:resource_response) { json['questions'].first }
      let(:resource) { questions.first }
      let(:public_fields) { %w[id title body created_at updated_at] }

      it_behaves_like 'GET collection'

      before { get api_path, params: { access_token: access_token.token }, headers: headers }


      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let!(:file1) { "#{Rails.root}/spec/rails_helper.rb" }
    let!(:file2) { "#{Rails.root}/spec/spec_helper.rb" }
    let!(:question) { create(:question, user: user) }
    let!(:comments) { create_list(:comment, 3, commentable: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    before do
      question.files.attach(io: File.open(file1), filename: 'file_helper.rb')
      question.files.attach(io: File.open(file2), filename: 'spec_helper.rb')
    end

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:resource_response) { json['question'] }
      let(:resource) { question }
      let(:public_fields) { %w[id title body created_at updated_at] }

      it_behaves_like 'GET resource'

      it 'return question' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        expect(json['question'].size).to eq 8
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }

    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'valid params' do
        let(:question_params) do
          {
            user_id: user.id,
            title: 'Test question',
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
          post api_path, params: { question: question_params, access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'saves a new question' do
          expect do
            post api_path, params: { question: question_params, access_token: access_token.token }, headers: headers
          end.to change(Question, :count).by(1)
        end
      end

      context 'invalid params' do
        let(:question_params) do
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

        it 'does not save a question' do
          expect do
            post api_path, params: { question: question_params, access_token: access_token.token }, headers: headers
          end.to_not change(Question, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'valid params' do
        let(:question_params) do
          {
            user_id: user.id,
            title: 'new title',
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
          patch api_path, params: { question: question_params, access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'change questions attributes' do
          patch api_path, params: { question: question_params, access_token: access_token.token }, headers: headers
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end
      end

      context 'invalid params' do
        let(:question_params) do
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

        it 'does not change question' do
          patch api_path, params: { question: question_params, access_token: access_token.token }, headers: headers
          question.reload

          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end
      end
    end
  end

  describe 'DELETE /api/v1/question/:id' do
    let(:user) { create(:user) }
    let!(:question) { create :question, user: user }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'Authorized user' do
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }
        let(:params) do
          { user_id: user.id }
        end

        it 'deletes the question' do
          expect do
            delete api_path, params: { question: params, access_token: access_token.token }, headers: headers
          end.to change(Question, :count).by(-1)
        end
      end

      context 'Unauthorized user' do
        let(:other_user) { create :user }
        let(:access_token) { create(:access_token, resource_owner_id: other_user.id) }
        let(:params) do
          { user_id: other_user.id }
        end

        it 'does not deletes the question' do
          expect do
            delete api_path, params: { question: params, access_token: access_token.token }, headers: headers
          end.to_not change(Question, :count)
        end
      end
    end
  end
end
