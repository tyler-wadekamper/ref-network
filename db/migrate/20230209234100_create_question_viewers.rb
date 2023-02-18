class CreateQuestionViewers < ActiveRecord::Migration[7.0]
  def change
    create_table :question_viewers do |t|
      t.belongs_to :viewer
      t.belongs_to :viewed_question

      t.timestamps
    end
  end
end
