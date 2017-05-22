require 'rails_helper'

RSpec.describe HomeController, type: :request do
  it "returns ok and a 200 for a successful request" do
    get home_index_path
    expect(response.status).to eq 200
    expect(response.body).to eq 'ok'
  end

  it "returns a 429 and a failure message when the rate limit is exceeded"
end
