FactoryBot.define do
  factory :default_user, class: User do
    first_name { 'User' }
    last_name { 'One' }
    email { 'user1@gmail.com' }
    password { 'UserOnePass' }
  end

  factory :random_user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(10) }
  end
end
