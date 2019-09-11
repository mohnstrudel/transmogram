include Utility

class FrontController < ApplicationController
  layout 'front'

  before_action :setup_footer
  before_action :setup_seo

  def setup_footer
    @footer_posts = Post.includes(:images).last(25)
  end

  def setup_seo
    @seo_meta_keywords = Utility::Seo.build_keywords
    @seo_meta_description = Utility::Seo.build_description
  end
end