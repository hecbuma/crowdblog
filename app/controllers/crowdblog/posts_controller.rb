module Crowdblog
  class PostsController < ApplicationController
    def index
      @posts = Crowdblog::Post.published_and_ordered
    end
  end
end
