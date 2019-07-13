class Front::UsersController < FrontController
  def show
    @user = User.includes(posts: :images).includes(posts: :comments).find(params[:id])
    @posts = @user.posts
    @tags = Post.joins(:hash_tags).includes(:hash_tags).where(user: @user).select{|post| p post.hash_tags}.pluck(:title).flatten
  end
end