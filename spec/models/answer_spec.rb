require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of(:body) }
  it { should have_db_column(:best).of_type(:boolean) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:answer2) { create(:answer, question: question) }

  describe 'set best attribute' do
    it 'to true' do
      answer.set_best

      expect(answer.best).to be_truthy
    end

    it 'back to false' do
      answer.set_best
      answer.set_best

      expect(answer.best).to be_falsey
    end

    it 'only one answer can be best' do
      answer.set_best
      answer2.set_best

      expect(question.answers.where(best: true).count).to eq 1
    end
  end

  describe 'best answer is first' do
    let(:answers) { create_list(:answer, 5, question: question) }

    it 'sort to first' do
      answer = answers.sample
      answer.set_best
      sorted_answers = answers.sort_by(&:best_answer_first)

      expect(sorted_answers.first).to eq answer
    end
  end
end
