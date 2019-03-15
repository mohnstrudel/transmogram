class Front::StaticPagesController < FrontController
  def home
    @posts = Post.all
  end
end
