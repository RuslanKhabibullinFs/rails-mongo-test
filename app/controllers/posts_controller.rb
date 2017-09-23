class PostsController < ApplicationController
  expose_decorated :posts, -> { filtered_posts }
  expose_decorated :post

  def new
  end

  def create
    post.save

    respond_with post
  end

  def show
  end

  def index
  end

  def edit
  end

  def update
    post.update_attributes(post_params)

    respond_with post, location: posts_path
  end

  def destroy
    post.destroy

    respond_with post, location: posts_path
  end

  private

  def filtered_posts
    @filtered_posts ||= params[:filter] ? PostFilterQuery.new(Post.all, filter_params).all : Post.all
  end

  def filter_params
    params.require(:filter).permit(:rating_filtration_value, :rating_sort_direction, categories: [])
  end

  def post_params
    params.require(:post).permit(:title, :content, :rating, categories: [])
  end
end
