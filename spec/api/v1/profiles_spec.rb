require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:verb) { :get }
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { send verb, api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Attrs returnable' do
        let(:attrs) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json['user'] }
        let(:resource) { me }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:verb) { :get }
    let(:api_path) { '/api/v1/profiles' }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:users) { create_list(:user, 5) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { send verb, api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it 'return all users but me' do
        expect(json['users'].size).to eq users.size - 1
        expect(json['users']).to_not include me.id
      end

      it_behaves_like 'Attrs returnable' do
        let(:attrs) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json['users'].last }
        let(:resource) { users.last }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
