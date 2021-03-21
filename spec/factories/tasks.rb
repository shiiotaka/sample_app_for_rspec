FactoryBot.define do
  factory :task do
    id { 1 }
    title {"test"}
    content {"test_content"}
    status { 1 }
    deadline { '2020/1/1'}
    user_id { 1 }

    association :user
  end
end
