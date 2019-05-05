require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  INVALID_URLS = %w[http:///foo.com buz http:// http://http:// https://rails. https://rails rails.com https://rails.com\questions].freeze
  it { should_not allow_values(INVALID_URLS).for(:url) }

  context 'test gist links' do
    let!(:question) { create(:question) }
    let(:regular_link) { question.links.create!(name: 'Regular link', url: 'http://ya.ru') }
    let(:gist_link) { question.links.create!(name: 'Gist link', url: 'https://gist.github.com/arbaev/53545d511a35e97da9afef00cf7770ea') }

    it 'gist link is gist?' do
      expect(gist_link).to be_gist_link
    end

    it 'regular link is gist?' do
      expect(regular_link).to_not be_gist_link
    end
  end
end
