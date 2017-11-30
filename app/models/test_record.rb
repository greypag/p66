class TestRecord < ApplicationRecord
  belongs_to :user

  mount_base64_uploader  :test_begin_photo, AvatarUploader
  mount_base64_uploader  :test_end_photo, AvatarUploader
end
