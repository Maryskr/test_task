class CommentsController < ApplicationController

  def create
    super
    if resource_params[:parent_id]
      parent = Subcomment.where(comment_id: resource_params[:parent_id])
      Subcomment.create(
          comment_id: resource_params[:parent_id],
          child_id: @new_resource.id,
          deeps: Comment.find(resource_params[:parent_id]).deeps + 1
        )
    end
  end

private
  def resource_params
     params.require(:comment).permit(
      :user_name, 
      :user_email, 
      :content,
      :article_id,
      :parent_id
    )
  end
end