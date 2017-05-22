# == Schema Information
#
# Table name: requests
#
#  id           :integer          not null, primary key
#  ip_address   :string
#  requested_at :datetime
#

class Request < ActiveRecord::Base
  validates :ip_address, :requested_at, presence: true

  scope :within_interval, -> (threshold_time) { where("requested_at > ?", threshold_time) }
  scope :for_ip_address, -> (request_ip) { where(ip_address: request_ip) }

  def self.requests_for_ip_during_time_period(ip_address, time_period: 60.minutes.ago)
    for_ip_address(ip_address).within_interval(time_period)
  end
end
