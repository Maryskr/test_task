class CommentsController < ApplicationController

  def create
    super
    # @comment = Comment.new(comment_params)
    # if params[:comment][:parent_id]
    #   parent = Subcomment.where(comment_id: params[:comment][:parent_id])
    #   Subcomment.create(
    #       comment_id: params[:comment][:parent_id]
    #       child_id: params[:comment][:id]
    #       deeps: parent.deeps + 1
    #     )
    # end
  end

private
  def resource_params
     params.require(:comment).permit(
      :user_name, 
      :user_email, 
      :content,
      :article_id
    )
  end
end