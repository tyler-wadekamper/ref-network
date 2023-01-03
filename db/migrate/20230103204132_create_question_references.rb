class CreateQuestionReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :question_references do |t|
      t.belongs_to :question
      t.belongs_to :reference

      t.timestamps
    end
  end
end
