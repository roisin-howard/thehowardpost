class BlogsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy] #user cannot access post creation page without being authenticated

  def index
    if params[:search]
      @blogs = Blog.search(params[:search]).order("created_at DESC")
    else
      @blogs = Blog.all.order('created_at DESC')
    end
  end

  def show
    @blog = Blog.find_by_id(params[:id])
  end

  def new
    @blog = Blog.new
  end

  def create
    if user_signed_in?
      @blog = Blog.new(blog_params)
      @blog.user = current_user
      if @blog.save
          redirect_to @blog, notice: "Blog created!"
      else
        render 'new'
      end
    else
      redirect_to blogs_path, alert: "Blog not created, user not logged in!"
    end
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update(blog_params_update)
      redirect_to blogs_path, notice: "Blog updated!"
    else
      render 'edit'
    end
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path, notice: "Blog deleted!"
  end

  private
    def blog_params
      params.require(:blog).permit(:title, :body, :users_id)
    end

    def blog_params_update
      params.require(:blog).permit(:title, :body, :user_id)
    end

end
