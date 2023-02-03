class AddReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :references do |t|
      t.string :rule
      t.string :section
      t.string :article
      t.string :subarticle
      t.string :name

      t.timestamps
    end
  end
end
