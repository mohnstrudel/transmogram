class FrontController < ApplicationController
  layout 'front'

  before_action :setup_footer

  def setup_footer
    @footer_posts = Post.includes(:images).last(25)
  end
end