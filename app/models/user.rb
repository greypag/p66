class User < ApplicationRecord
  has_many :messages
  has_many :payment_records
  has_many :test_records
  has_many :scores

  attr_accessor :password_confirmation, :email_confirmation

  mount_uploader :avatar, AvatarUploader

  def admin?
    is_admin
  end

  def rater?
    is_rater
  end
end
