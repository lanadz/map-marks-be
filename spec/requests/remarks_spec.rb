require 'rails_helper'

RSpec.describe '/remarks' do
  let(:remark) do
    create(:remark)
  end

  describe 'GET /remarks' do
    context 'when records are available' do
      let!(:remark1) { create(:remark) }
      let!(:remark2) { create(:remark) }

      it 'returns 200 ok with records' do
        get '/remarks.json'
        expect(response.status).to eq(200)
        expect(json.size).to eq(2)

        remark = json.find {|remark| remark['id'] == remark1.id }
        expect(remark['user_name']).to eq(remark1.user_name)
        expect(remark['body']).to eq(remark1.body)
        expect(remark['lat']).to eq(remark1.lat)
        expect(remark['lng']).to eq(remark1.lng)
        expect(remark['created_at']).to_not eq(nil)
        expect(remark['updated_at']).to_not eq(nil)

        remark = json.find {|remark| remark['id'] == remark2.id }
        expect(remark['user_name']).to eq(remark2.user_name)
        expect(remark['body']).to eq(remark2.body)
        expect(remark['lat']).to eq(remark2.lat)
        expect(remark['lng']).to eq(remark2.lng)
        expect(remark['created_at']).to_not eq(nil)
        expect(remark['updated_at']).to_not eq(nil)
      end
    end

    context 'with search parameters' do
      let!(:remark1) { create(:remark, user_name: 'john') }
      let!(:remark2) { create(:remark, user_name: 'oliver') }

      it 'returns 200 ok with records' do
        get '/remarks.json', params: { q: 'john', lng: remark1.lng - 0.01, lat: remark1.lat, radius: 1000 }
        expect(response.status).to eq(200)
        expect(json.size).to eq(1)

        remark = json.find {|remark| remark['id'] == remark1.id }
        expect(remark['user_name']).to eq(remark1.user_name)
        expect(remark['body']).to eq(remark1.body)
        expect(remark['lat']).to eq(remark1.lat)
        expect(remark['lng']).to eq(remark1.lng)
        expect(remark['distance']).to eq(760)
        expect(remark['created_at']).to_not eq(nil)
        expect(remark['updated_at']).to_not eq(nil)
      end
    end

    context 'when there are no records' do
      it 'returns 200 ok with records' do
        get '/remarks.json'
        expect(response.status).to eq(200)
        expect(json.size).to eq(0)
      end
    end
  end

  describe 'POST /remarks' do
    context 'when valid params are passed' do
      let(:params) do
        {
            user_name: 'John',
            body: 'I was here',
            lat: '-22',
            lng: '47',
        }
      end
      it 'returns 201 ok with record' do
        expect {
          post "/remarks.json", params: { remark: params }
        }.to change(Remark, :count).by(1)

        expect(response.status).to eq(201)

        remark = Remark.find(json['id'])

        expect(remark.id).to eq(json['id'])
        expect(remark.user_name).to eq('John')
        expect(remark.body).to eq('I was here')
        expect(remark.lat).to eq(-22)
        expect(remark.lng).to eq(47)
        expect(remark.created_at).to_not eq(nil)
        expect(remark.updated_at).to_not eq(nil)
      end
    end

    context 'when params are missing' do
      let(:params) do
        {
            user_name: 'John',
            lat: '-22',
        }
      end
      it 'returns 422 with errors' do
        expect {
          post "/remarks.json", params: { remark: params }
        }.to_not change(Remark, :count)

        expect(response.status).to eq(422)
        expect(json_errors).to eq(["param is missing or the value is empty: lng"])
      end
    end

    context 'when params are invalid' do
      let(:params) do
        {
            user_name: 'John',
            body: 'I was here',
            lat: 'abc',
            lng: '47',
        }
      end
      it 'returns 422 with errors' do
        expect {
          post "/remarks.json", params: { remark: params }
        }.to_not change(Remark, :count)

        expect(response.status).to eq(422)
        expect(json_errors).to eq(["Point GPS coordinates are invalid"])
      end
    end
  end
end