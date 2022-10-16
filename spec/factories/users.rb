# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    role { :client }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    birth_date { 20.years.ago }
    factory :musician do
      role { :musician }
      gender { %i[male female].sample }
    end
    factory :musician_group do
      role { :musician_group }
      number_of_participants { Faker::Number.between(from: 1, to: 10) }
    end
  end
end
