class Front::PostsController < FrontController
  include ActionView::Helpers::UrlHelper
  impressionist :actions=>[:show]
  before_action :find_post, only: [:upvote, :downvote, :edit, :update, :destroy]

  def new
    # unless current_user
    #   redirect_to root_path
    #   flash[:alarm] = "You must be logged in to create a new post. #{link_to 'Sign Up', new_user_registration_path} or #{link_to 'Log In', new_user_session_path}"
    # end
    @post = Post.new
    @user = user_signed_in? ? current_user : User.new
  end

  def show
    begin
      @post = Post.includes(:comments).includes(:images).active_images.friendly.find(params[:id])
      @post_images = @post.images.active
      @post_user = @post.user

      @page_title = @post.title
      @page_description = @post.description
      @page_keywords = @post.extract_name_hash_tags.push(*@seo_meta_keywords).uniq
      set_meta_tags title: @page_title, description: @page_description, keywords: @page_keywords, og: { image: "#{request.protocol}#{request.host_with_port}" + @post.images.first.image_value[:large].url}
    rescue ActiveRecord::RecordNotFound => e
      @post = :not_active
    end
    @similar_posts = Post.last(3)
  end

  def edit
    @user = current_user
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

    if @post.valid?
      @post.user = User.find_or_create_with_params(params[:user])
    end

    begin
      if @post.save
        flash[:success] = "Your post upload request was created. If your images do contain WoW characters, everything will be okay and your post should appear within a minute on the main page."
        redirect_to root_path
      else
        flash[:alarm] = ["Errors encountered:", @post.errors.full_messages]
        redirect_to new_post_path
      end
    rescue => e
      logger.info "Posts controller ´create´ action. Error: #{e.inspect}"
      flash[:alarm] = "Errors encountered: #{e.full_messages}"
      redirect_to new_post_path
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
    @post = Post.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, :user_id, :title, :armor_type_id, :class_type_id,
      images_attributes: [:id, :image_value, :_destroy, :post_id])
  end
end
