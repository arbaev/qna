require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question, 5) }
      let(:question) { questions.first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

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
