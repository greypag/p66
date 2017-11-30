class AddOrderToResponse < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :order, :integer
  end
end
