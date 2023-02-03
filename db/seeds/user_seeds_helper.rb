require 'faker'

def seed_users
  (15..30).each do |id|
    User.create!(
              id: id, 
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              password: "password", 
              password_confirmation: "password")
  end
end
