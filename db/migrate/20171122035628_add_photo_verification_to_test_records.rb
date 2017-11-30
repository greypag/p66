class AddPhotoVerificationToTestRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :test_records, :photo_verification, :integer, default: 0
  end
end
