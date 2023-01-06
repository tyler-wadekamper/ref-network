# Reference seeds can be seeded alone using this file by running "rails db:seed:reference_seeds"

require 'csv'

def field_empty?(string, row)
  row.field(string).to_s.strip.empty?
end

def no_subarticle?(row, previous_row)
  return true if previous_row.nil?

  field_empty?('subarticle', row)
end

current_path = File.dirname(__FILE__)
file_path = File.join(current_path, 'seed_references.csv')

previous_row = nil

CSV.foreach(file_path, headers: true) do |row|
  if no_subarticle?(row, previous_row)
    rule = row.field('rule')
    section = row.field('section')
    article = row.field('article')
  else
    rule = previous_row.field('rule')
    section = previous_row.field('section')
    article = previous_row.field('article')
  end

  subarticle = row.field('subarticle')
  subarticle = subarticle.downcase if subarticle

  name = row.field('name')

  Reference.create!(rule:, section:, article:, subarticle:, name:)

  previous_row = row if no_subarticle?(row, previous_row)
end