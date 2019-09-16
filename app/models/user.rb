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

  def self.find_or_create_with_params(user_params)
    return if user_params.nil?

    email = user_params[:email]
    nickname = user_params[:nickname]
    password = SecureRandom.base64

    if email.present?
      User.find_or_create_by(email: email) do |user|
        user.nickname = nickname
        user.password = password
      end
    else
      User.create(email: Faker::Internet.email, nickname: Faker::Internet.username, password: password, roles: {"random_user" => true})
    end
  end

  def admin?
    return false if roles.nil?
    roles.fetch("admin")
  end

  private

  def subscribe
    Utility::Mailchimp.subscribe(self)
  end
end
