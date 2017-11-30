class AddPromptsToTests < ActiveRecord::Migration[5.1]
  def change
    add_column :tests, :status, :integer, default: 0
    add_column :tests, :language, :string
    add_column :tests, :industry, :string
    add_column :tests, :ilr1_prompt1, :string
    add_column :tests, :ilr1_prompt2, :string
    add_column :tests, :ilr1plus_prompt1, :string
    add_column :tests, :ilr1plus_prompt2, :string
    add_column :tests, :ilr2_prompt1, :string
    add_column :tests, :ilr2_prompt2, :string
    add_column :tests, :ilr2plus_prompt1, :string
    add_column :tests, :ilr2plus_prompt2, :string
    add_column :tests, :ilr3_prompt1, :string
    add_column :tests, :ilr3_prompt2, :string
  end
end
