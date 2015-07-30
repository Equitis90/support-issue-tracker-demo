FactoryGirl.define do
  time = Time.now

  factory :user do
    login Faker::Internet.user_name
    username Faker::Name.name
    admin false
    created_at time
    updated_at time
  end

  factory :department do
    title Faker::Commerce.department
    created_at time
    updated_at time
  end

  factory :ticket do
    creator_name Faker::Internet.user_name
    creator_email Faker::Internet.email
    created_at time
    updated_at time
  end

  factory :ticket_message do
    text Faker::Lorem.sentence
    created_at time
    updated_at time
  end

  factory :ticket_status do
    title 'Waiting for Staff Response'
    created_at time
    updated_at time
  end
end