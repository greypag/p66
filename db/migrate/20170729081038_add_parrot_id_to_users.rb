class AddParrotIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :parrot_id, :string
  end
end
