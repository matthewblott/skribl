FactoryBot.define do
  factory :note do
    sequence(:title) { |n| "Note #{n}" }
    content { "This is the content of note #{title}" }
  end
end