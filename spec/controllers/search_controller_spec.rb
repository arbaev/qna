require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #results' do
    let(:questions) { create_list(:question, 5) }

    context 'with valid attributes' do
      Services::Search::AREAS.each do |area|
        before do
          allow(Services::Search).to receive(:call).and_return(questions)

          get :results, params: { q: questions.sample.title, resource: area }
        end

        it "#{area} return OK" do
          expect(response).to be_successful
        end

        it "renders #{area} results view" do
          expect(response).to render_template :results
        end

        it "#{area} assign Services::Search.call to @results" do
          expect(assigns(:results)).to eq questions
        end
      end
    end

    context 'with invalid attributes' do
      before do
        allow(Services::Search).to receive(:call).and_return(questions)

        get :results, params: { resource: '' }
      end

      it "got 302 status" do
        expect(response.status).to eq 302
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
