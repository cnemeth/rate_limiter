FactoryGirl.define do
  factory :rate_limit do
    ip_address Faker::Internet.ip_v4_address
    requested_at Faker::Time.between(DateTime.now - 1, DateTime.now)
  end
end
