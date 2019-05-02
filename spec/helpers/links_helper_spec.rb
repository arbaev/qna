require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let!(:question) { create(:question) }
  let(:regular_link) { question.links.create!(name: 'Regular link', url: 'http://ya.ru') }
  let(:gist_link) { question.links.create!(name: 'Gist link', url: 'https://gist.github.com/arbaev/53545d511a35e97da9afef00cf7770ea') }

  describe '#link_and_gist' do
    it 'render regular link tag' do
      link_tag_expected = "<a href=\"#{regular_link.url}\">#{regular_link.name}</a>"

      expect(helper.link_and_gist(regular_link)).to eq link_tag_expected
    end

    it 'render gist link tag' do
      expect(helper.link_and_gist(gist_link)).to include gist_link.url
    end

    it 'render gist' do
      expect(helper.link_and_gist(gist_link)).to include '@question.author = current_user'
    end
  end
end
