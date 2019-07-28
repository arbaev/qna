require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question, 5) }
      let(:question) { questions.first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all questions' do
        expect(json['questions'].size).to eq questions.size
      end

      it 'returns all public fields for question' do
        user_fields = %w[id title body created_at updated_at]

        user_fields.each do |attr|
          expect(json['questions'].last[attr]).to eq questions.last.send(attr).as_json
        end
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { json['questions'].first['answers'] }

        it 'returns all question answers' do
          expect(answer_response.size).to eq answers.size
        end

        it 'returns all public fields for question answers' do
          user_fields = %w[id body created_at updated_at]

          user_fields.each do |attr|
            expect(answer_response.first[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
