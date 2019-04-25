FactoryBot.define do
  factory :remark do
    user_name { "John" }
    body { "I was here" }
    point { 'POINT(-22 47)' }
  end
end
