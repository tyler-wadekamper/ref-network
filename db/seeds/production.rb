# "rails db:seed" defaults to the development environment. In order to seed the production database, you must run "rails db:seed RAILS_ENV=production".

require_relative "seeds_helper"

author = User.where(email: "tyler.wadekamper@gmail.com")[0]

seed_questions(author:)