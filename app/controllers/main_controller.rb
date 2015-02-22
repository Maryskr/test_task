class MainController < ApplicationController

  def index
    @article = Article.first
  end
end