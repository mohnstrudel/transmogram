class Image < ApplicationRecord
  belongs_to :post
  include ImageUploader::Attachment.new(:image_value) # adds an `image` virtual attribute

  validates :image_value, presence: true
end
