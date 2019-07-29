require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create :question }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:response_answers) { json['answers'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      context 'answers' do
        it_behaves_like 'All items returnable' do
          let(:resource_response) { response_answers }
          let(:resource) { answers }
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[id body created_at updated_at author_id] }
          let(:resource_response) { response_answers.first }
          let(:resource) { answers.first }
        end
      end
    end
  end
end
