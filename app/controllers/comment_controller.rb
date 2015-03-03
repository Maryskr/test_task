class CommentController < ApplicationController

  def create
    super
  end

  def update
    super
  end

private
  def resource_params
     params.require(:comment).permit(
      :id,
      :user_name, 
      :user_email, 
      :content,
      :article_id,
      :parent_id,
      :rating,
      :deeps
    )
  end
end