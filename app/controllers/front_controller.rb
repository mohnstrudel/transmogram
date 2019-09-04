class FrontController < ApplicationController
  layout 'front'

  before_action :setup_footer
  before_action :setup_seo

  def setup_footer
    @footer_posts = Post.includes(:images).last(25)
  end

  def setup_seo
    @seo_meta_keywords = ["world of warcraft", "transmogrification", "transmog", "tmog", "wow", 'transmog fashion', 'wow fashion', 'world of warcraft fashion', 'world of warcraft transmog fashion']
    @seo_meta_description = "Transmogram.com - your World of Warcraft Transmogrification showroom. Show case your best and most stylish WoW Tier Sets or other custom fashion builds. Review other peoples creations, comment and upvote them!"
  end
end