# == Schema Information
#
# Table name: rate_limits
#
#  id           :integer          not null, primary key
#  ip_address   :string
#  requested_at :datetime
#

class RateLimit < ActiveRecord::Base
  validates :ip_address, :requested_at, presence: true

  scope :within_interval, -> (threshold_time) { where("requested_at > ?", threshold_time) }
  scope :for_ip_address, -> (request_ip) { where(ip_address: request_ip) }

  def self.request_for_ip_during_time_period(ip_address, time_period: 60.minutes.ago)
    for_ip_address(ip_address).within_interval(time_period)
  end

  def self.request_permitted(ip_address, maximum_requests: 100, time_period: 60.minutes.ago)
    requests = request_for_ip_during_time_period(ip_address, time_period: time_period)
    requests.size < maximum_requests
  end
end
