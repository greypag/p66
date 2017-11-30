class AddAvatarsToPrompts < ActiveRecord::Migration[5.1]
  def change
    add_column :prompts, :image, :string
    add_column :prompts, :video, :string
    add_column :prompts, :audio, :string
  end
end
