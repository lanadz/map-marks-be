require 'rails_helper'

RSpec.describe Remark do
  subject(:remark) do
    build(:remark)
  end

  context 'validations' do
    it 'is valida by default' do
      expect(remark.valid?).to eq(true)
    end

    it 'validates presence of body' do
      remark.body = nil
      expect(remark.valid?).to eq(false)
    end

    it 'validates GPS point values' do
      remark.point = nil
      expect(remark.valid?).to eq(false)

      remark.point = "POINT(180 90)"
      expect(remark.valid?).to eq(true)

      remark.point = "POINT(180 abc)"
      expect(remark.valid?).to eq(false)
    end
  end

  context 'setting GPS coordinates' do
    it 'normalizes degrees if we pass lng value bigger than expected' do
      remark.point = "POINT(180 90)"
      expect(remark.lng).to eq(180)
      expect(remark.lat).to eq(90)

      remark.point = "POINT(183 90)"
      expect(remark.lng).to eq(-177)
      expect(remark.lat).to eq(90)
    end

    it 'auto fixes lat value (sets it to closes min (-90) or max (90) value' do
      remark.point = "POINT(1.23 90)"
      expect(remark.lng).to eq(1.23)
      expect(remark.lat).to eq(90)

      remark.point = "POINT(0 91)"
      expect(remark.lng).to eq(0)
      expect(remark.lat).to eq(90)

      remark.point = "POINT(0.1 -91)"
      expect(remark.lng).to eq(0.1)
      expect(remark.lat).to eq(-90)
    end
  end
end