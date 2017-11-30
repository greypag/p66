class AddPromptToResponse < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :prompt_id, :integer
  end
end
