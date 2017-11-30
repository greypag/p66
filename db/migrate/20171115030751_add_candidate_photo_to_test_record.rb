class AddCandidatePhotoToTestRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :test_records, :test_begin_photo, :string
    add_column :test_records, :test_end_photo, :string
  end
end
