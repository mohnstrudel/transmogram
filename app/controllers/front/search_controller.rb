class Front::SearchController < FrontController
  def index
    if params[:query].start_with?('#')
      query  = params[:query].gsub('#', '')
      @posts = Post.joins(:hash_tags).where(hash_tags: {name:    query})
    else
      @posts = Post.where("lower(description) like ?", "%#{params[:query].downcase}%")
    end
  end
end
