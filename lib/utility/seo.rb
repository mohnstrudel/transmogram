module Utility
  class Seo
    def self.build_keywords
      class_array = %w(druid shaman dk deathknight hunter warrior monk warlock wl mage paladin pala rogue roug priest demonhunter dh)
      variable_keywords = ["transmog", "outfit", "transmog outfit", "wow transmog", "wow transmog outfit"]

      keywords = class_array.product(variable_keywords).map { |element| element.join(' ')}

      misc = ["world of warcraft", "transmogrification", "transmog", "tmog", "wow", 'transmog fashion', 'wow fashion', 'world of warcraft fashion', 'world of warcraft transmog fashion']

      misc.push(keywords).flatten
    end

    def self.build_description
      description = "Transmogram.com - your World of Warcraft Transmogrification showroom. Show case your best and most stylish WoW Tier Sets or other custom fashion builds. Review other peoples creations, comment and upvote them!"
      description += build_keywords.join(", ")
    end
  end
end