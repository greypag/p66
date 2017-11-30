class Prompt < ApplicationRecord
  # has_many :responses
  mount_uploader :video, VideoUploader
  mount_uploader :audio, AudioUploader
  mount_uploader :image, AvatarUploader

end
