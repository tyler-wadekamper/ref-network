class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.string :team
      t.string :down
      t.string :distance
      t.string :yardline_team
      t.string :yardline_num
      t.string :clock_status

      t.timestamps
    end
  end
end
