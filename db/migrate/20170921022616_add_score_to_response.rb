class AddScoreToResponse < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :score, :string
    add_column :responses, :status, :integer, default: 0
  end
end
