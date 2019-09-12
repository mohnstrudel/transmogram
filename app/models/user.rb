class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  audited
  has_associated_audits

  acts_as_voter

  after_create :subscribe

  include ImageUploader::Attachment.new(:avatar) # adds an `avatar` virtual attribute
  # mount_uploader :avatar, AvatarUploader

  def admin?
    return false if roles.nil?
    roles.fetch("admin")
  end

  private

  def subscribe
    Utility::Mailchimp.subscribe(self)
  end
end
