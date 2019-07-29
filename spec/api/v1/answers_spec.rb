require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }
  let(:question) { create :question }

  describe 'GET /api/v1/questions/:question_id/answers' do
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

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create :answer, :with_attachment, question: question }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:links) { create_list(:link, 3, linkable: answer) }
      let!(:files) { answer.files }
      let!(:comments) { create_list(:comments_list, 3, commentable: answer) }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

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
end
