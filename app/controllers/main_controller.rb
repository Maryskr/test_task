class MainController < ApplicationController

  def index 
    respond_to do |format|
      format.html do
        @article = Article.first
        @comments = @article.comments
        gon.current_resource = @comments.as_json(methods: :deeps)
        gon.article = @article
      end
    end
  end
end