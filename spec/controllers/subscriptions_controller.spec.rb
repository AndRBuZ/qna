require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:question_invalid) { create(:question, :invalid) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new subscription' do
          expect do
            post :create, params: { question_id: question }, format: :js
          end.to change(Subscription, :count).by(1)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save the subscription' do
        expect { post :create, params: { question_id: question }, format: :js }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create :subscription, user_id: user.id }

    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'destroy subscription' do
          expect { delete :destroy, params: { question_id: question, id: subscription }, format: :js }.to change(Subscription, :count).by(-1)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not destroy subscription' do
        expect { delete :destroy, params: { question_id: question, id: subscription }, format: :js }.to_not change(Subscription, :count)
      end
    end
  end
end
