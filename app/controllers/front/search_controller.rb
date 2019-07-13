class Front::SearchController < FrontController
  include Pagy::Backend

  def index
    if params[:query].empty?
      @pagy, @posts = pagy(Post.all, link_extra: 'data-remote="true" class="my-class"')

    elsif params[:query].start_with?('#')
      query  = params[:query].gsub('#', '')
      @pagy, @posts = pagy(Post.joins(:hash_tags).where(hash_tags: {name:    query}).where(search), link_extra: 'data-remote="true" class="my-class"')
    else
      @pagy, @posts = pagy(Post.where("lower(description) like ?", "%#{params[:query].downcase}%").where(search), link_extra: 'data-remote="true" class="my-class"')
    end
  end

  def search
    # query_obj = joins(:profile => :addresses)
    # query_obj = query_obj.where("city like ?", "%#{city}%") unless city.blank?
    # query_obj = query_obj.where("state = ?", state) unless state.blank?
    # query_obj = query_obj.where("zip like ?", "%#{zip}%") unless zip.blank?
    conditions = {class_type: params[:class_type], armor_type: params[:armor_type]}
    conditions.delete_if {|key,val| val.blank? }

    conditions
  end
end
