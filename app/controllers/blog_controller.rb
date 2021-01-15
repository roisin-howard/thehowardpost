class BlogController < ApplicationController
  def index
    @search_flag = false
    if params[:search]
      @search_flag = true
      @blogs = Blog.search(params[:search]).order("created_at DESC")
    else
      @blogs = Blog.all.order('created_at DESC')
    end
  end

  def show
    @blog = Blog.find_by_id(params[:id])
    @user = User.find_by_id(@blog.users_id)
    @user_name = @user.first_name + " " +  @user.last_name
  end

  def new
    @blog = Blog.new
  end

  def create
    if user_signed_in?
      @blog = Blog.new(blog_params)
      @blog.users_id = current_user.id
      if @blog.save
          redirect_to @blog, notice: "Blog created!"
      else 
        redirect_to blog_index_path, alert: "Blog not created, could not be saved!"
      end
    else
      redirect_to blog_index_path, alert: "Blog not created, user not logged in!"
    end
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update(blog_params_update)
      redirect_to blog_index_path, notice: "Blog updated!"
    else
      redirect_to blog_index_path, alert: "Blog could not be updated!"
    end
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blog_index_path, notice: "Blog deleted!"
  end

  private
    def blog_params
      params.permit(:title, :body)
    end

    def blog_params_update
      params.require(:blog).permit(:title, :body)
    end

end
