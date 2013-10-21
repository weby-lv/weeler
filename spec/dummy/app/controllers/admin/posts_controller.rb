class Admin::PostsController < Weeler::BaseController


  def index
    @posts = Post.all
  end

end