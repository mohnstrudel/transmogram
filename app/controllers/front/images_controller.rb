class Front::ImagesController < FrontController
  def create
    @image = Image.new(image_params)
    @image.save
  end

  def index
    redirect_to root_path unless current_user.admin?
    @images = Image.where(active: false)
  end

  def activate
    @image = Image.find(params[:id])
    if @image.update(active: true)
      @images= Image.where(active: false)
      respond_to do |format|
        format.js { render 'activate', layout: false }
      end
    end
  end

  def destroy
    @image = Image.find(params[:id])
    if @image.destroy
      if @image.post.images.empty?
        @image.post.destroy
        puts "Post, associated with images, destroyed"
      end
      @images= Image.where(active: false)
      respond_to do |format|
        format.js { render 'destroy', layout: false }
      end
    end
  end

  private

  def image_params
    params.require(:image).permit(:id, :value, :post_id)
  end
end