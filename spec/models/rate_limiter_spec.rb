require 'rails_helper'

RSpec.describe RateLimiter, type: :model do

  let(:ip_address) { '127.0.0.1' }
  let!(:rate_limiter) { RateLimiter.new(ip_address: ip_address) }

  it 'knows the IP address that the rate limit is for' do
    expect(rate_limiter.ip_address).to eq ip_address
  end

  context do
    let(:request_ip) { '127.0.0.1' }
    let(:other_ip)   { '10.0.0.10' }
    let!(:previous_request) do
      (1..10).each do |number|
        create(:request, ip_address: request_ip, requested_at: number.minutes.ago)
      end
    end
    let!(:other_request) do
      (1..10).each do |number|
        create(:request, ip_address: other_ip, requested_at: number.minutes.ago)
      end
    end
    let(:valid_rate_limiter) { RateLimiter.new(ip_address: ip_address) }
    let(:invalid_rate_limiter) {
      RateLimiter.new(ip_address: ip_address, maximum_requests: 5, time_period: 10.minutes.ago)
    }

    it 'can get the requests for a time period' do
      expect(valid_rate_limiter.requests.size).to eq 10
    end

    it 'reports if a request is permitted' do
      expect(valid_rate_limiter.request_permitted?).to be true
    end

    it 'reports if a request is not permitted' do
      expect(invalid_rate_limiter.request_permitted?).to eq false
    end

    it 'reports how long until a request from a non-permitted IP address can be made' do
      expect(invalid_rate_limiter.time_until_next_request_permitted).
        to include "Rate limit exceeded, please try again"
    end
  end
end
