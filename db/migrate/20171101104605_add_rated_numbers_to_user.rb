class AddRatedNumbersToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :weekly_rated, :integer
    add_column :users, :total_rated, :integer
  end
end
