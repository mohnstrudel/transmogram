class Post < ApplicationRecord
  belongs_to :user
  audited associated_with: :user

  belongs_to :armor_type, optional: true
  belongs_to :class_type, optional: true

  acts_as_commentable
  acts_as_votable

  # has_many :active_images, class_name: 'Image', ->{ Image.active }
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  is_impressionable

  has_many :post_hash_tags, dependent: :destroy
  has_many :hash_tags, through: :post_hash_tags

  # scope :active_images, -> { where(images: any?) }
  scope :active_images, ->{
    joins(:images).merge(Image.active)
  }

  after_commit :create_hash_tags, on: :create

  validates :title, :armor_type, :class_type, presence: true
  validate :image_presence

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def create_hash_tags
    extract_name_hash_tags.each do |name|
      # Check if a HashTag already exists (we dont want to duplicate HashTags!)
      hash_tag_object = HashTag.find_or_create_by(name: name)
      # Increase the counter
      hash_tag_object.increment!(:count)
      # Create the binding record
      post_hash_tags.create(post_id: id, hash_tag_id: hash_tag_object.id)
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
