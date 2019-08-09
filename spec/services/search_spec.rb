require 'rails_helper'

RSpec.describe Services::Search do
  it 'calls search global' do
    expect(ThinkingSphinx).to receive(:search).with('test string')
    Services::Search.call(q: 'test string', resource: 'Global')
  end

  Services::Search::AREAS.drop(1).each do |area|
    it "calls search from #{area} class" do
      expect(area.singularize.constantize).to receive(:search).with('test string')
      Services::Search.call(q: 'test string', resource: area)
    end
  end
end
