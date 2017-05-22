# == Schema Information
#
# Table name: requests
#
#  id           :integer          not null, primary key
#  ip_address   :string
#  requested_at :datetime
#

require 'rails_helper'

RSpec.describe Request, type: :model do

  it 'requires and IP address' do
    request_request = Request.new
    request_request.requested_at = Time.zone.now
    expect(request_request).to_not be_valid
    request_request.ip_address = '127.0.0.1'
    expect(request_request.save).to eq true
  end

  it 'requires a timestamp the request was made' do
    request_request = Request.new
    request_request.ip_address = '127.0.0.1'
    expect(request_request).to_not be_valid
    request_request.requested_at = Time.zone.now
    expect(request_request.save).to eq true
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

    it 'orders the requests by requested at, newest to oldest' do
      requests = Request.requests_for_ip_during_time_period(request_ip)
      requests.each_with_index do |request, counter|
        if counter < (requests.size - 1) # Don't try to compare the last one against something outside the array
          expect(request.requested_at > requests[counter + 1].requested_at).to eq(true)
        end
      end
    end

    it 'can count up requests for over a time perior' do
      expect(Request.within_interval(60.minutes.ago).size).to eq 20
    end

    it 'can count up requests for a requesting IP address' do
      expect(Request.for_ip_address(request_ip).size).to eq 10
      expect(Request.for_ip_address(other_ip).size).to eq 10
    end

    it 'can count requests for a requesting IP address over a time period' do
      expect(Request.requests_for_ip_during_time_period(request_ip).size).to eq 10
      expect(Request.requests_for_ip_during_time_period(request_ip, time_period: 6.minutes.ago).size).to eq 5
    end
  end
end
