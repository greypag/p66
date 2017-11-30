class AddIsRaterToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_rater, :boolean, default: false
  end
end
