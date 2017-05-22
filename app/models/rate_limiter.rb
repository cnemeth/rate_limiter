class RateLimiter
  attr_accessor :ip_address, :maximum_requests, :time_period
  attr_reader :requests

  def initialize(**args)
    params = defaults.merge!(args)
    @ip_address = params[:ip_address] || ''
    @maximum_requests = params[:maximum_requests]
    @time_period = params[:time_period]
  end

  def requests
    @requests ||= Request.request_for_ip_during_time_period(ip_address, time_period: time_period).limit(maximum_requests)
  end

  def request_permitted?
    requests.size < maximum_requests
  end

  def time_until_next_request_permitted
    interval = Time.zone.now - time_period
    next_request_at = (requests.last.requested_at + interval)
    next_request_in = (next_request_at - Time.zone.now).to_i
    "Rate limit exceeded, please try again in #{next_request_in} seconds"
  end

  private

  def defaults
    {
      maximum_requests: 100,
      time_period: 60.minutes.ago
    }
  end
end
