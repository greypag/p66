class AddAncestryToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :ancestry, :string
    add_index :messages, :ancestry
  end
end
