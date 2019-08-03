require 'rails_helper'

RSpec.describe NewAnswersJob, type: :job do
  let(:service) { double('Services::NewAnswers') }
  let(:answer) { create :answer }

  before do
    allow(Services::NewAnswer).to receive(:new).and_return(service)
  end

  it 'calls Services::NewAnswers#send_notification' do
    expect(service).to receive(:send_notification)
    NewAnswersJob.perform_now(answer)
  end
end
