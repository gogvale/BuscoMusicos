# frozen_string_literal: true

FactoryBot.define do
  factory :refresh_token do
    token { Faker::Alphanumeric.alphanumeric }
    user { create(:musician) }
    expire_at { 1.hour.from_now }
  end
end
