require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:question) { create :question }
  let(:me) { create :user }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:answer) { create :answer, question: question, author: me }
  let(:answer_response) { json['answer'] }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:verb) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:response_answers) { json['answers'] }

      before { send verb, api_path, params: { access_token: access_token.token }, headers: headers }

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

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create :answer, :with_attachment, question: question }
    let(:verb) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:links) { create_list(:link, 3, linkable: answer) }
      let!(:files) { answer.files }
      let!(:comments) { create_list(:comments_list, 3, commentable: answer) }

      before { send verb, api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      context 'answer' do
        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[id body created_at updated_at author_id] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end
      end

      context "answer's comments" do
        it_behaves_like 'All items returnable' do
          let(:resource_response) { answer_response['comments'] }
          let(:resource) { comments }
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[id body created_at updated_at author_id] }
          let(:resource_response) { answer_response['comments'].first }
          let(:resource) { comments.last }
        end
      end

      context "answer's links" do
        it_behaves_like 'All items returnable' do
          let(:resource_response) { answer_response['links'] }
          let(:resource) { links }
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[id name url created_at updated_at] }
          let(:resource_response) { answer_response['links'].first }
          let(:resource) { links.last }
        end
      end

      context "answer's attachments" do
        it_behaves_like 'All items returnable' do
          let(:resource_response) { answer_response['files'] }
          let(:resource) { files }
        end

        it "returns url fields for answer's files" do
          expect(answer_response['files'].first['url']).to eq rails_blob_path(files.first, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:verb) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      describe 'create answer with valid attrs' do
        let(:params) { { access_token: access_token.token,
                         answer: { body: answer.body } } }

        before { send verb, api_path, headers: headers, params: params }

        it 'returns :created status' do
          expect(response.status).to eq 201
        end

        it 'saves a new answer in the database' do
          expect(Answer.count).to eq 2
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[body] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end

        it 'new answer belongs to the logged user' do
          expect(answer_response['author']['id']).to eq me.id
        end
      end

      describe 'create answer with invalid attrs' do
        let(:params) { { access_token: access_token.token,
                         answer: { body: nil } } }

        before { send verb, api_path, headers: headers, params: params }

        it 'returns :unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'does not saves a new answer to the database' do
          expect(Answer.count).to eq 0
        end

        it 'returns error message' do
          expect(json['errors']).to be_truthy
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:verb) { :patch }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      describe 'create answer with valid attrs' do
        let(:params) { { access_token: access_token.token,
                         answer: { body: answer.body } } }

        before { send verb, api_path, headers: headers, params: params }

        it 'returns :created status' do
          expect(response.status).to eq 201
        end

        it 'saves an updated question to the database' do
          expect(Answer.count).to eq 1
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[body] }
          let(:resource_response) { answer }
          let(:resource) { answer }
        end

        it 'updated answer belongs to the logged user' do
          expect(answer_response['author']['id']).to eq me.id
        end
      end

      describe 'create answer with invalid attrs' do
        let(:params) { { access_token: access_token.token,
                         answer: { body: nil } } }

        before { patch api_path, headers: headers, params: params }

        it 'returns :unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'does not saves a new answer to the database' do
          expect(Answer.count).to eq 1
        end

        it 'returns error message' do
          expect(json['errors']).to be_truthy
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:verb) { :delete }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      describe 'delete the answer' do
        let(:params) { { access_token: access_token.token,
                         answer_id: answer.id } }

        before { send verb, api_path, headers: headers, params: params }

        it 'returns :ok status' do
          expect(response.status).to eq 200
        end

        it 'deletes the answer from the database' do
          expect(Answer.count).to eq 0
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end
      end
    end
  end
end
