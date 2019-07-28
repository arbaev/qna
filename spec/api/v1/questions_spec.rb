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
        public_fields = %w[id title body created_at updated_at]

        public_fields.each do |attr|
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
          public_fields = %w[id body created_at updated_at]

          public_fields.each do |attr|
            expect(answer_response.first[attr]).to eq answer.send(attr).as_json
          end
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

      it 'returns all public fields for question' do
        public_fields = %w[id title body created_at updated_at]

        public_fields.each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns all question answers' do
        expect(question_response['answers'].size).to eq answers.size
      end

      it 'returns all public fields for question answers' do
        public_fields = %w[id body created_at updated_at author_id]

        public_fields.each do |attr|
          expect(question_response['answers'].first[attr]).to eq answers.first.send(attr).as_json
        end
      end

      it 'returns all question comments' do
        expect(question_response['comments'].size).to eq comments.size
      end

      it 'returns all public fields for question comments' do
        public_fields = %w[id body created_at updated_at author_id]
        public_fields.each do |attr|
          expect(question_response['comments'].first[attr]).to eq comments.last.send(attr).as_json
        end
      end

      it 'returns all question links' do
        expect(question_response['links'].size).to eq links.size
      end

      it 'returns all public fields for question links' do
        public_fields = %w[id name url created_at updated_at]
        public_fields.each do |attr|
          expect(question_response['links'].first[attr]).to eq links.last.send(attr).as_json
        end
      end

      it 'returns all question files' do
        expect(question_response['files'].size).to eq files.size
      end

      it 'returns url fields for question files' do
        expect(question_response['files'].first['url']).to eq rails_blob_path(files.first, only_path: true)
      end
    end
  end
end
