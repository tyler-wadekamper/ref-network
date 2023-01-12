class AddTextAndLengthToReference < ActiveRecord::Migration[7.0]
  def change
    add_column :references, :text, :string
    add_column :references, :length, :integer
  end
end
