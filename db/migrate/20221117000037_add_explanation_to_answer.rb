class AddExplanationToAnswer < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :explanation, :string
  end
end
