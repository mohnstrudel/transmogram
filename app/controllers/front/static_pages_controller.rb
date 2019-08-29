class Front::StaticPagesController < FrontController
  include Pagy::Backend

  def home
    @tags = Rails.cache.fetch("top_tags") do
      HashTag.most_popular_tags
      # returns an array of arrays, i.e.
      # [[2, "images", 7], [1, "frutti", 5], [4, "ce", 2], [5, "whatsapp", 0], [3, "cyber", 0]]
    end
    @pagy, @posts = pagy(Post.all, link_extra: 'data-remote="true" class="my-class"')
    # Usage: @pagy, @records = pagy(Product.some_scope)
    # Old call: @posts = Post.all
  end

  def help
  end

  def contact
  end
end
