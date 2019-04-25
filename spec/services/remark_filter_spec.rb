require 'rails_helper'

RSpec.describe RemarkFilter do
  let!(:remark1) do
    create(:remark, user_name: 'john', body: 'i was here', point: 'POINT(0.30 3.50)')
  end
  let!(:remark2) do
    create(:remark, user_name: 'john', body: 'nice place', point: 'POINT(0.25 3.40)')
  end
  let!(:remark3) do
    create(:remark, user_name: 'oliver', body: 'fancy place', point: 'POINT(15.90 -32.10)')
  end

  subject(:filter) do
    RemarkFilter.new(params).run
  end

  context 'empty filters' do
    let(:params) do
      {}
    end
    it 'returns all remarks' do
      expect(filter.size).to eq(3)
      expect(filter).to match_array([remark1, remark2, remark3])
    end
  end

  context 'filter by position and radius' do
    context 'radius is too small to cover 2 remarks' do
      let(:params) do
        { lng: '0.301', lat: '3.501', radius: 500 }
      end
      it 'returns closest remark' do
        expect(filter.size).to eq(1)
        expect(filter).to match_array([remark1])
      end
    end

    context 'radius is big enough to cover 2 remarks' do
      let(:params) do
        { lng: '0.301', lat: '3.501', radius: 15000 }
      end
      it 'returns 2 remark which are close to each other' do
        expect(filter.size).to eq(2)
        expect(filter).to match_array([remark1, remark2])
      end
    end
  end

  context 'filter by exact username' do
    let(:params) do
      { q: 'john' }
    end
    it 'returns all remarks created by john' do
      expect(filter.size).to eq(2)
      expect(filter).to match_array([remark1, remark2])
    end
  end

  context 'filter by partial username' do
    let(:params) do
      { q: 'jo' }
    end
    it 'returns all remarks created by john' do
      expect(filter.size).to eq(2)
      expect(filter).to match_array([remark1, remark2])
    end
  end

  context 'filter by partial body message' do
    let(:params) do
      { q: 'place' }
    end
    it 'returns all remarks with work `place` in the body' do
      expect(filter.size).to eq(2)
      expect(filter).to match_array([remark2, remark3])
    end
  end
end