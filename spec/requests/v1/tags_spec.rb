require 'rails_helper'

RSpec.describe 'V1::Tags', type: :request do
  let(:tags) { FactoryBot.create_list(:tag, 5) }

  context 'v1' do
    before(:each) { Tag.destroy_all }

    describe '#index' do
      it 'gets all tags when there are no tags yet' do
        get "/v1/tags"
        expect(Tag.count).to eq(0)
        expect(response).to have_http_status(:no_content)
      end

      it 'get all tags without search' do
        tags
        get "/v1/tags"
        expect(Tag.count).to eq(5)
        expect(response).to have_http_status(200)
        tags.each do |t|
          expect(response.body).to include(t.name)
        end
      end

      it 'get all tags with search' do
        t1 = FactoryBot.create(:tag, name: 'One')
        t2 = FactoryBot.create(:tag, name: 'MiOne')
        t3 = FactoryBot.create(:tag, name: 'unrelated')
        get "/v1/tags?query=One"
        expect(response).to have_http_status(200)
        expect(response.body).to     include(t1.name)
        expect(response.body).to     include(t2.name)
        expect(response.body).not_to include(t3.name)
      end

    end
  end
end

