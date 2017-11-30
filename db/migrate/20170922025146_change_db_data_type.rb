class ChangeDbDataType < ActiveRecord::Migration[5.1]
  def change
    change_column :prompts, :level, :integer
    change_column :responses, :level, :integer
    change_column :qars, :level, :integer
  end
end
