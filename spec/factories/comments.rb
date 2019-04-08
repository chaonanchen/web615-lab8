FactoryBot.define do
  factory :comment do
    sequence(:message) { |n| "Message_#{n}" } # This allows for many comments to be created at the same time
    user # This requires that a user model to be created (or specified) and associated with the record
    article # this requires that an article model to be created and associated with the record
  end
end
