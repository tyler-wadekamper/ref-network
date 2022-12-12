FactoryBot.define do
  factory :default_user, class: User do
    first_name: { 'Henry' }
    last_name: { 'Blathers' }
    email { 'henry58@gmail.com' }
    password: { 'BigHen58' }
  end

  factory :random_user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(10) }
  end
end
