class Front::SearchController < FrontController
  include Pagy::Backend

  def index
    if params[:query].start_with?('#')
      query  = params[:query].gsub('#', '')
      @pagy, @posts = pagy(Post.joins(:hash_tags).where(hash_tags: {name:    query}), link_extra: 'data-remote="true" class="my-class"')
    else
      @pagy, @posts = pagy(Post.where("lower(description) like ?", "%#{params[:query].downcase}%"), link_extra: 'data-remote="true" class="my-class"')
    end
  end
end
