module Front
  class CommentsController < FrontController
    def create
      @comment = Comment.new(comment: params[:comment], commentable_type: params[:object], commentable_id: params[:object_id], user_id: params[:user_id])

      if @comment.save
        respond_to do |format|
          format.js { render 'create', layout: false }
        end
      end
    end
  end
end