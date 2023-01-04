# Reference seeds can be seeded alone using this file by running "rails db:seed:reference_seeds"

require 'csv'

def assign_if_present(string, row, previous_row)
  return row.field(string) unless previous_row

  return previous_row.field(string) if field_empty?(string, row)

  row.field(string)
end

def field_empty?(string, row)
  row.field(string).to_s.strip.empty?
end

current_path = File.dirname(__FILE__)
file_path = File.join(current_path, 'seed_references.csv')

previous_row = nil

CSV.foreach(file_path, headers: true) do |row|
  rule = assign_if_present('rule', row, previous_row)
  section = assign_if_present('section', row, previous_row)
  article = assign_if_present('article', row, previous_row)
  subarticle = row.field('subarticle')

  subarticle = subarticle.downcase if subarticle

  name = row.field('name')

  Reference.create!(rule:, section:, article:, subarticle:, name:)

  previous_row = row unless field_empty?('rule', row)
end