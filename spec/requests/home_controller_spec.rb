require 'rails_helper'

RSpec.describe HomeController, type: :request do
  it "returns ok and a 200 for a successful request" do
    get home_index_path
    expect(response.status).to eq 200
    expect(response.body).to eq 'ok'
  end

  it "takes a record of a successful request" do
    expect{
      get home_index_path
    }.to change{Request.count}.by(1)
  end

  context 'hitting the rate limit' do
    let!(:request) do
      (1..99).each do |number|
        create(:request, ip_address: '127.0.0.1', requested_at: number.seconds.ago)
      end
    end

    it "returns a 429 if the rate limit is exceeded" do
      get home_index_path
      expect(response.status).to eq 200
      expect(response.body).to eq 'ok'

      get home_index_path
      expect(response.status).to eq 429
      expect(response.body).to include "Rate limit exceeded, please try again"
    end
  end
end
