require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:request_create_subscription) { post :create, params: { question_id: question.id }, format: :js }

    context 'Authenticated user' do
      before { login user }

      it 'return 200 for logged user' do
        request_create_subscription

        expect(response).to be_successful
      end

      it 'saves a new subscription to the database' do
        expect { request_create_subscription }.to change(question.subscriptions, :count).by(1)
      end

      it 'new subscription belongs to the logged user' do
        request_create_subscription

        expect(question.subscriptions.last.user).to eq user
      end
    end

    context 'Non-authenticated user' do
      it 'return 401 for not logged user' do
        request_create_subscription

        expect(response.status).to eq 401
      end

      it 'does not saves a new subscription to the database' do
        expect { request_create_subscription }.to_not change(question.subscriptions, :count)
      end
    end
  end


  describe 'DELETE #destroy' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let!(:subscription) { create :subscription, user: user, question: question }
    let(:request_delete_subscription) { delete :destroy, params: { id: subscription }, format: :js }

    context 'Authenticated user' do
      before { login user }

      it 'deletes subscription from user' do
        expect { request_delete_subscription }.to change(user.subscriptions, :count).by(-1)
      end

      it 'deletes subscription from question' do
        expect { request_delete_subscription }.to change(question.subscriptions, :count).by(-1)
      end
    end

    context 'Non-authenticated user' do
      it 'return 401 for not logged user' do
        request_delete_subscription

        expect(response.status).to eq 401
      end

      it 'does not saves a new subscription to the database' do
        expect { request_delete_subscription }.to_not change(Subscription, :count)
      end
    end
  end
end
