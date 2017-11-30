class AddUserIdAndTestIdToResponse < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :user_id, :integer
    add_column :responses, :test_id, :integer
  end
end
