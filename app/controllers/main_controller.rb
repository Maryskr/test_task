class MainController < ApplicationController

  def index
    @article = Article.first
    @comments = @article.comments
  end
end