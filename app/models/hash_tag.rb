class HashTag < ApplicationRecord
  has_many :post_hash_tags, dependent: :destroy
  has_many :posts, through: :post_hash_tags

  def self.most_popular_tags
    array_of_hash_tags = pluck(:id, :name, :count)
    result = array_of_hash_tags.sort_by { |item| item[2] }.reverse
    result.first(10)
  end
end
