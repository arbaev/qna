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

      it_behaves_like 'All items returnable' do
        let(:resource_response) { json['questions'] }
        let(:resource) { questions }
      end

      it_behaves_like 'Attrs returnable' do
        let(:attrs) { %w[id title body created_at updated_at] }
        let(:resource_response) { json['questions'].last }
        let(:resource) { questions.last }
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { json['questions'].first['answers'] }

        it_behaves_like 'All items returnable' do
          let(:resource_response) { answer_response }
          let(:resource) { answers }
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[id body created_at updated_at] }
          let(:resource_response) { answer_response.first }
          let(:resource) { answer }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create :question, :with_attachment }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let!(:files) { question.files }
      let!(:comments) { create_list(:comments_list, 3, commentable: question) }
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      context 'question' do
        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[id title body created_at updated_at] }
          let(:resource_response) { question_response }
          let(:resource) { question }
        end
      end

      context 'question answers' do
        it_behaves_like 'All items returnable' do
          let(:resource_response) { question_response['answers'] }
          let(:resource) { answers }
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[id body created_at updated_at author_id] }
          let(:resource_response) { question_response['answers'].first }
          let(:resource) { answers.first }
        end
      end

      context 'question comments' do
        it_behaves_like 'All items returnable' do
          let(:resource_response) { question_response['comments'] }
          let(:resource) { comments }
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[id body created_at updated_at author_id] }
          let(:resource_response) { question_response['comments'].first }
          let(:resource) { comments.last }
        end
      end

      context 'question links' do
        it_behaves_like 'All items returnable' do
          let(:resource_response) { question_response['links'] }
          let(:resource) { links }
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[id name url created_at updated_at] }
          let(:resource_response) { question_response['links'].first }
          let(:resource) { links.last }
        end
      end

      context 'question attachments' do
        it_behaves_like 'All items returnable' do
          let(:resource_response) { question_response['files'] }
          let(:resource) { files }
        end

        it 'returns url fields for question files' do
          expect(question_response['files'].first['url']).to eq rails_blob_path(files.first, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions" }
    let(:headers) { { "ACCEPT" => "application/json" } }
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:me) { create :user }
      let(:question) { create :question, author: me }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:question_response) { json['question'] }

      describe 'create question with valid attrs' do
        let(:params) { { access_token: access_token.token,
                         question: { title: question.title, body: question.body } } }

        before { post api_path, headers: headers, params: params }

        it 'returns :created status' do
          expect(response.status).to eq 201
        end

        it 'saves a new question in the database' do
          expect(Question.count).to eq 2
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[title body] }
          let(:resource_response) { question_response }
          let(:resource) { question }
        end

        it 'new question belongs to the logged user' do
          expect(question_response['author']['id']).to eq me.id
        end
      end

      describe 'create question with invalid attrs' do
        let(:params) { { access_token: access_token.token,
                         question: { title: nil, body: nil } } }

        before { post api_path, headers: headers, params: params }

        it 'returns :unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'does not saves a new question in the database' do
          expect(Question.count).to eq 0
        end

        it 'returns error message' do
          expect(json['errors']).to be_truthy
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:me) { create :user }
    let(:question) { create :question, author: me }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:headers) { { "ACCEPT" => "application/json" } }
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:question_response) { json['question'] }

      describe 'create question with valid attrs' do
        let(:params) { { access_token: access_token.token,
                         question: { title: question.title, body: question.body } } }

        before { patch api_path, headers: headers, params: params }

        it 'returns :created status' do
          expect(response.status).to eq 201
        end

        it 'saves an updated question to the database' do
          expect(Question.count).to eq 1
        end

        it_behaves_like 'Attrs returnable' do
          let(:attrs) { %w[title body] }
          let(:resource_response) { question_response }
          let(:resource) { question }
        end

        it 'updated question belongs to the logged user' do
          expect(question_response['author']['id']).to eq me.id
        end
      end

      describe 'create question with invalid attrs' do
        let(:params) { { access_token: access_token.token,
                         question: { title: nil, body: nil } } }

        before { patch api_path, headers: headers, params: params }

        it 'returns :unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'does not saves a new question in the database' do
          expect(Question.count).to eq 1
        end

        it 'returns error message' do
          expect(json['errors']).to be_truthy
        end
      end
    end
  end
end
