class Post < ApplicationRecord
  belongs_to :user
  belongs_to :armor_type, optional: true
  belongs_to :class_type, optional: true

  acts_as_commentable
  acts_as_votable

  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  is_impressionable

  has_many :post_hash_tags, dependent: :destroy
  has_many :hash_tags, through: :post_hash_tags

  # scope :with_images, -> { where(images: any?) }

  after_commit :create_hash_tags, on: :create

  validates :title, :armor_type, :class_type, presence: true
  validate :image_presence

  # def self.create(attributes = nil, &block)
  #   UploadWorker.perform_async(super)
  # end

  def create_hash_tags
    extract_name_hash_tags.each do |name|
      hash_tags.create(name: name)
    end
  end

  def extract_name_hash_tags
    description.to_s.scan(/#\w+/).map{|name| name.gsub("#", "")}
  end

  def description_preview
    description.truncate(10)
  end

  def top_tags
    hash_tags.pluck(:name).first(5).map{|item| "#"+item}.join(", ")
  end

  def image_presence
    self.errors[:base] << "Select at least one image" if images.empty?
  end
end
