require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { question_id: question, user_id: user, answer: attributes_for(:answer) },
                        format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) },
                        format: :js
        end.to_not change(question.answers, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'delete the question' do
      it 'changes answer count' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #best' do
    context 'Author of the question' do
      before { login(user) }

      it 'mark as best' do
        patch :best, params: { id: answer, format: :js }
        answer.reload
        expect(answer).to be_best
      end

      it 'render best template' do
        patch :best, params: { id: answer, format: :js }
        expect(response).to render_template :best
      end
    end

    context 'Not author of the question' do
      before { login(second_user) }

      it 'tries to mark as best' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to_not be_best
      end

      it 'render best template' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end
  end
end
