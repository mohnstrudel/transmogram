class Front::StaticPagesController < FrontController
  include Pagy::Backend

  def home
    @pagy, @posts = pagy(Post.all, link_extra: 'data-remote="true" class="my-class"')
    # Usage: @pagy, @records = pagy(Product.some_scope)
    # Old call: @posts = Post.all
  end

  def help
  end

  def contact
  end
end
