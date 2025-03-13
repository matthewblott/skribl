FactoryBot.define do
  factory :note do
    sequence(:content) { |n| "This is the content of note #{n}" }
  end
end
