class AddParentToReference < ActiveRecord::Migration[7.0]
  def change
    add_reference :references, :parent, index: true
  end
end
