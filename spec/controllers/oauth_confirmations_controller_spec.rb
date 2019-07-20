require 'rails_helper'

RSpec.describe OauthConfirmationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #new' do

    it 'renders new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:email) { 'just_a_test_email@mail848.com' }

    context 'with valid attributes' do
      it 'saves a new user in the database' do
        expect { post :create, params: { email: email } }.to change(User, :count).by(1)
      end

      # если это нужно проверять в контроллере, то как?
      it 'send confirmation instructions'

      it 'render create view' do
        post :create, params: { email: email }

        expect(response).to render_template :create
      end
    end
  end

end
