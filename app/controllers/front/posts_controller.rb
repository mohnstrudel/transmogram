class Front::PostsController < FrontController
  include ActionView::Helpers::UrlHelper
  impressionist :actions=>[:show]
  before_action :find_post, only: [:upvote, :downvote, :edit, :update, :destroy]

  def new
    unless current_user
      redirect_to root_path
      flash[:alarm] = "You must be logged in to create a new post. #{link_to 'Sign Up', new_user_registration_path} or #{link_to 'Log In', new_user_session_path}"
    end
    @post = Post.new
  end

  def show
    @post = Post.active_images.includes(:comments).find(params[:id])
    @similar_posts = Post.last(3)
  end

  def edit
  end

  def update
    if @post.update(file_params)
      flash[:success] = "Your post was updated successfully"
      redirect_to edit_post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = "Your post was destroyed. You evil thing."
      redirect_to root_path
    else
      render :edit
    end
  end

  def create
      @post = Post.new(file_params)

    begin
      if @post.save
        flash[:success] = "Your post upload request was created. If your images do contain WoW characters, everything will be okay and your post should appear within a minute on the main page."
        redirect_to root_path
        # if params[:images].present?
        #   params[:images].each { |image| @post.active_images.create(image_value: image, validate: true) }
      else
        # @post.errors[:base] << "You must attach at least one image"
        flash[:alarm] = ["Errors encountered:", @post.errors.full_messages]
        # flash[:alarm] = "Errors encountered: #{@post.errors.full_messages.join("\n")}"
        # @post.destroy
        render :new
      end
    rescue => e
      logger.info "Posts controller ´create´ action. Error: #{e.inspect}"
      flash[:alarm] = "Errors encountered: #{e.full_messages}"
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

  def file_params
    if params[:files].present?
      # transform the list of uploaded files into a photos attributes hash
      new_images_attributes = params[:files].inject({}) do |hash, file|
        hash.merge!(SecureRandom.hex => { image_value: file })
      end
      # merge new images attributes with existing (`post_params` is whitelisted `params[:post]`)
      images_attributes = post_params[:images_attributes].to_h.merge(new_images_attributes)
      post_attributes  = post_params.merge(images_attributes: images_attributes)

      return post_attributes
    else
      return post_params
    end
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, :user_id, :title, :armor_type_id, :class_type_id,
      images_attributes: [:id, :image_value, :_destroy, :post_id])
  end
end
