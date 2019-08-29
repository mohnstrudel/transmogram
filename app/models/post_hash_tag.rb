class PostHashTag < ApplicationRecord
  belongs_to :post
  belongs_to :hash_tag

  # after_save :increase_occurance

  # private

  # def increase_occurance
  #   HashTag.find(hash_tag_id).increment!(:count)
  # end
end
