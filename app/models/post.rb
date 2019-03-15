class Post < ApplicationRecord
  belongs_to :user
  acts_as_commentable
  acts_as_votable

  mount_uploaders :images, ImageUploader

  is_impressionable

  has_many :post_hash_tags, dependent: :destroy
  has_many :hash_tags, through: :post_hash_tags

  after_commit :create_hash_tags, on: :create

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
end
