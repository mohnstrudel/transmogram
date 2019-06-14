class Front::ImagesController < FrontController
  def create
    @image = Image.new(image_params)
    @image.save
  end

  private

  def image_params
    params.require(:image).permit(:id, :value, :post_id)
  end
end