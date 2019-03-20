class Front::PostsController < FrontController
  impressionist :actions=>[:show]
  before_action :find_post, only: [:upvote, :downvote]

  def new
  end

  def show
    @post = Post.includes(:comments).find(params[:id])
    @similar_posts = Post.last(3)
  end

  def create
    begin
      Post.create!(post_params)
      redirect_to root_path
    rescue => e
      puts "Error: #{e.inspect}"
    end
  end

  def upvote
    @post.upvote_by current_user
    redirect_to root_path
  end

  def downvote
    @post.downvote_by current_user
    redirect_to :back
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, :user_id, {images: []})
  end
end
