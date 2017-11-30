class Response < ApplicationRecord
  mount_uploader :avatar, AudioUploader
end
