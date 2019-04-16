class Front::PostsController < FrontController
  include ActionView::Helpers::UrlHelper
  impressionist :actions=>[:show]
  before_action :find_post, only: [:upvote, :downvote]

  def new
    unless current_user
      redirect_to root_path
      flash[:alarm] = "You must be logged in to create a new post. #{link_to 'Sign Up', new_user_registration_path} or #{link_to 'Log In', new_user_session_path}"
    end
  end

  def show
    @post = Post.includes(:comments).find(params[:id])
    @similar_posts = Post.last(3)
  end

  def create
    @post = Post.build(post_params)
    begin
      if @post.valid?
        # proceed with background job and save the post
        UploadWorker.perform_async(@post.id)
        flash.now[:success] = "Your post upload request was created. If your images do contain WoW characters, everything will be okay and your post should appear within a minute on the main page."
        redirect_to root_path
      else
        flash[:alarm] = "Errors encountered: #{@post.errors.full_messages.join('; ')}"
        render :new
      end
    rescue => e
      puts "Posts controller ´create´ action. Error: #{e.inspect}"
      flash.now[:alarm] = "Errors encountered: #{e.full_messages}"
      render :new
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
    params.require(:post).permit(:description, :user_id, { images: [] }, :title, :armor_type_id, :class_type_id)
  end
end
