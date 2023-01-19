class AddLabelToReference < ActiveRecord::Migration[7.0]
  def change
    add_column :references, :label, :string
  end
end
